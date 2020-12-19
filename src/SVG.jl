export SVG, CSS, RCP, svg_css, svg_class, set_href, svg_document, SvgContent, GradientContent, radialGradient_template, linearGradient_template, svg_doc_recipe, svg_canvas_recipe


# Get default elements and attributes
const SVG = get_json(string(PKG_ROOT_DIR,"/assets/svg/","svg.json"))
const CSS = get_json(string(PKG_ROOT_DIR,"/assets/svg/","css.json"))
const RCP = get_json(string(PKG_ROOT_DIR,"/assets/svg/","recipes.json"))

"""
================================================================================
# SVG specific types and functions
================================================================================

A unique differenciator can be used for elements.
Example: "svg_rect"

SVG specific definitions:

A generic SVG document:

- svg element
- style element
- defs element
- main area

"""

# Run main function to create functions based on the SVG JSON file.
# A prefix is optional but recommended because of potential conflicts with Julia functions or types with same names.
# Example: svg filter element
PREF = "svg_"

generate(copy(SVG),PREF)

# function wrapper for template functions

function wrap(n,a=Dict(),c=string())
    f = Symbol(n)
    eval(quote $f($a,$c) end )
end

# Composite type: Minimal structure of a svg document
mutable struct SvgContent
    style
    defs
    main
    function SvgContent(style=wrap(string(PREF,"style")),defs=wrap(string(PREF,"defs")),main=wrap(string(PREF,"g")))
        new(style,defs,main)
    end
end

# Creates the actual svg document
function svg_document(a::Dict=SVG["svg"],c::SvgContent=SvgContent())
    return wrap(string(PREF,"svg"),a,string(c.style,c.defs,c.main))

end

# Creates a svg css class string
function svg_class(type::String,values::Dict,id::String=Random.randstring(8))
    c = string()
    for (k,v) in values c = string(c,k,":",v,";") end
    return string(type,".",id,"{",c,"} ")
end

function svg_css(children::Array{String,1})
    return string("<![CDATA[ ",join(children)," ]]>")
end

# Set href value string for styles and symbols. If true (default), the href value is being formatted for css, otherwise for element references.
function set_href(value,c::Bool=true)
      return c == true ? string("url(#",value,")") : string("#",value)
end

# Templates: Gradients
mutable struct GradientContent
    stop1
    stop2
    function GradientContent(stop1=wrap(string(PREF,"stop")),stop2=wrap(string(PREF,"stop")))
        new(stop1,stop2)
    end
end

function radialGradient_template(a::Dict=SVG["radialGradient"],c::GradientContent=GradientContent())
    return wrap(string(PREF,"radialGradient"),a,string(c.stop1,c.stop2))
end

function linearGradient_template(a::Dict=SVG["linearGradient"],c::GradientContent=GradientContent())
    return wrap(string(PREF,"linearGradient"),a,string(c.stop1,c.stop2))
end

"""

================================================================================
# SVG Recipes
================================================================================

Recipes are parametric document templates with a corresponding json file


"""

# A simple svg document. Just a rectangle with a radial gradient background
function svg_doc_recipe(p::Dict=get_attributes(RCP,@funcName))

    # Id's
    radialGradient_id = set_random_id()
    rect_style_id = set_random_id()

    # Gradients
    radialGradient = get_attributes(SVG,"radialGradient")
    radialGradient["id"] = radialGradient_id

    grad_content = GradientContent()
    grad_content.stop1 = svg_stop(Dict(
       "stop-color"=>p["color1"],
       "offset"=>p["offset1"]
    ))
    grad_content.stop2 = svg_stop(Dict(
       "stop-color"=>p["color2"],
       "offset"=>p["offset2"]
    ))

    # CSS
    rect_style = get_attributes(CSS,"rect")
    rect_style["fill"] = set_href(radialGradient_id)
    rect_style_class = svg_class("rect",rect_style,rect_style_id)

    # Canvas
    rect = get_attributes(SVG,"rect")
    delete!(rect, "style")
    rect["class"] = rect_style_id
    rect["x"] = p["x"]
    rect["y"] = p["y"]
    rect["width"] = p["w"]
    rect["height"] = p["h"]

    # Assemble the document

    doc = SvgContent()

    doc.style = svg_style(Dict(),svg_css([rect_style_class]))
    doc.defs = svg_defs(Dict("id"=>"defs"),radialGradient_template(radialGradient,grad_content))

    content = svg_rect(rect)
    doc.main = svg_g(Dict("id"=>"main"),content)

    svg =  get_attributes(SVG,"svg")
    svg["viewBox"] = join_str([p["x"],p["y"],p["w"],p["h"]])

    return svg_document(svg,doc)

end

# See abstract_rectangle in Abstract.jl
function svg_canvas_recipe(p::Dict=get_attributes(RCP,@funcName))

   # Build Gradients

   rect_radialGradient_id = set_random_id()
   rect_radialGradient = get_attributes(SVG,"radialGradient")
   rect_radialGradient["id"] = rect_radialGradient_id

   rect_grad_content = GradientContent()
   rect_grad_content.stop1 = svg_stop(Dict(
     "stop-color"=>p["rect_color1"],
     "offset"=>p["rect_offset1"]
   ))
   rect_grad_content.stop2 = svg_stop(Dict(
     "stop-color"=>p["rect_color2"],
     "offset"=>p["rect_offset2"]
   ))

   circle_radialGradient_id = set_random_id()
   circle_radialGradient = get_attributes(SVG,"radialGradient")
   circle_radialGradient["id"] = circle_radialGradient_id

   circle_grad_content = GradientContent()
   circle_grad_content.stop1 = svg_stop(Dict(
     "stop-color"=>p["circle_color1"],
     "offset"=>p["circle_offset1"]
   ))
   circle_grad_content.stop2 = svg_stop(Dict(
     "stop-color"=>p["circle_color2"],
     "offset"=>p["circle_offset2"]
   ))

   # Add all gradients to dev element
   defs = string(
      radialGradient_template(rect_radialGradient,rect_grad_content),
      radialGradient_template(circle_radialGradient,circle_grad_content)
      )

   # Build CSS Classes
   rect_style_id = set_random_id()
   rect_style = get_attributes(CSS,"rect")
   rect_style["fill"] = set_href(rect_radialGradient_id)
   rect_style_class = svg_class("rect",rect_style,rect_style_id)

   circle_style_id = set_random_id()
   circle_style = get_attributes(CSS,"rect")
   circle_style["fill"] = set_href(circle_radialGradient_id)
   circle_style_class = svg_class("circle",circle_style,circle_style_id)

   classes = svg_css([rect_style_class,circle_style_class])

   # Build Elements
   el = string()
   ae = abstract_rectangle(p)
   r = string((parse(Float64,ae.r)/parse(Float64,p["factor"])))

   # Create the rectangle

   ra = get_attributes(SVG,"rect")
   if p["class"] == "yes"
     delete!(ra, "style")
     ra["class"] = rect_style_id
   end
   ra["x"] = ae.points["tl"].x
   ra["y"] = ae.points["tl"].y
   ra["width"] = ae.w
   ra["height"] = ae.h
   el = string(el, svg_rect(ra))

   # Create the circles
   for (k,v) in ae.points
         ar = get_attributes(SVG,"circle")
         if p["class"] == "yes"
           delete!(ar, "style")
           ar["class"] = circle_style_id
         end
         ar["cx"] = v.x
         ar["cy"] = v.y
         ar["r"] = r
         # if p[k] != k ar["class"] = p[k] end
         el = string(el, svg_circle(ar))
   end

   # create cross lines
   lv = get_attributes(SVG,"line")
   lh = get_attributes(SVG,"line")

   lv["x1"] = ae.points["mt"].x
   lv["y1"] = ae.points["mt"].y
   lv["x2"] = ae.points["mb"].x
   lv["y2"] = ae.points["mb"].y
   # if p["lv"] != "lv" lv["class"] = p["lv"] end

   lh["x1"] = ae.points["mr"].x
   lh["y1"] = ae.points["mr"].y
   lh["x2"] = ae.points["ml"].x
   lh["y2"] = ae.points["ml"].y
   # if p["lh"] != "lh" lh["class"] = p["lh"] end

   el = string(el,svg_line(lv),svg_line(lh))

   ga = get_attributes(SVG,"g")
   ga["type"] = @funcName

   content = svg_g(ga,el)

   # Assemble the document

   doc = SvgContent()

   doc.style = svg_style(Dict(),classes)
   doc.defs = svg_defs(Dict("id"=>"defs"),defs)

   doc.main = svg_g(Dict("id"=>"main"),content)

   svg =  get_attributes(SVG,"svg")
   svg["viewBox"] = join_str([p["x"],p["y"],p["w"],p["h"]])

   return svg_document(svg,doc)

end
