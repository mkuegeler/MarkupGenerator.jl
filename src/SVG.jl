export SVG, CSS, svg_css, svg_document, SvgContent

# Get default elements and attributes
const SVG = get_json(string(PKG_ROOT_DIR,"/assets/svg/","svg.json"))
const CSS = get_json(string(PKG_ROOT_DIR,"/assets/svg/","css.json"))

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

# Run main function to create functions based on the SVG JSON file
PREF = "svg_"

generate(SVG,PREF)


# function wrapper for type SvgContent

function wrap(n)
    f = Symbol(n)
    eval(quote $f() end )
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
    return svg_svg(a,string(c.style,c.defs,c.main))

end

# Creates a svg css class string
function svg_class(type::String,values::Dict,id::String=Random.randstring(8))
    c = string()
    for (k,v) in values c = string(c,k,":",v,";") end
    return string(type,".",id,"{",c,"} ")
end

# Creates css content for a svg style element
function svg_css(children::Dict)
    c = string()
    for (k,v) in children
        c = string(c,svg_class(k,v))
    end
    return string("<![CDATA[ ",c," ]]>")
end
