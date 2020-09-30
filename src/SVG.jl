export SVG, CSS, RCP, svg_css, svg_class, set_href, svg_document, SvgContent, GradientContent, radialGradient_template, linearGradient_template, svg_doc_recipe


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

generate(SVG,PREF)


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


# Recipes
function svg_doc_recipe(p::Dict=RCP["svg_doc_recipe"])

    # Id's
    radialGradient_id = set_random_id()
    rect_style_id = set_random_id()

    # Gradients
    radialGradient = SVG["radialGradient"]
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
    rect_style = CSS["rect"]
    rect_style["fill"] = set_href(radialGradient_id)
    rect_style_class = svg_class("rect",rect_style,rect_style_id)

    # Canvas
    rect = SVG["rect"]
    delete!(rect, "style")
    rect["class"] = rect_style_id
    rect["x"] = p["x"]
    rect["y"] = p["y"]
    rect["width"] = p["width"]
    rect["height"] = p["height"]

    # Assemble the document

    doc = SvgContent()

    doc.style = svg_style(Dict(),svg_css([rect_style_class]))
    doc.defs = svg_defs(Dict("id"=>"defs"),radialGradient_template(radialGradient,grad_content))
    doc.main = svg_g(Dict("id"=>"main"),svg_rect(rect))

    svg = SVG["svg"]
    svg["viewBox"] = join_str([p["x"],p["y"],p["width"],p["height"]])

    return svg_document(Dict("id"=>"root"),doc)

end
