export svg_document, LIB, CSS, Cpnt, svg_css

"""
================================================================================
# SVG specific types and functions
================================================================================
"""

# Get default elements and attributes
const LIB = get_json(string(PKG_ROOT_DIR,"/assets/svg/","svg.json"))
const CSS = get_json(string(PKG_ROOT_DIR,"/assets/svg/","css.json"))

"""
A unique differenciator can be used for elements.
Example: "svg_rect"

"""

# Run main function to create functions based on the SVG JSON file
generate(LIB,"svg")

"""
SVG specific definitions:

A generic SVG document:

- svg element
- style element
- defs element
- main area

"""

# Component type
mutable struct Cpnt
    attributes::Dict
    children::String
    function Cpnt(attributes::Dict=Dict(),children::String=string())
        new(attributes,children)
    end
end

function svg_document(r::Cpnt=Cpnt(),s::Cpnt=Cpnt(),d::Cpnt=Cpnt(),c::Cpnt=Cpnt())
    style = svg_style(s.attributes,s.children)
    defs = svg_defs(d.attributes,d.children)
    canvas = svg_g(c.attributes,c.children)
    return svg_svg(r.attributes,string(style,defs,canvas))
end

function svg_class(type::String,values::Dict,id::String=Random.randstring(8))
    c = string()
    for (k,v) in values c = string(c,k,":",v,";") end
    return string(type,".",id,"{",c,"} ")
end

function svg_css(children::Dict)
    c = string()
    for (k,v) in children
        c = string(c,svg_class(k,v))
    end
    return string("<![CDATA[ ",c," ]]>")
end
