export element

"""

Core types and functions for generic markup elements and attributes

"""

# Composite type for markup constructs that begin with < and ends with >

# Example: <svg id="root">content</svg>
struct StartAttributesEndTag
  name::String
  attribute_list::String
  function StartAttributesEndTag(name,attribute_list)
    return Dict("start" => string("<",name, attribute_list,">"), "end" => string("</",name,">"))
  end
end

# Example: <svg id="root"/>
struct StartAttributeTag
  name::String
  attribute_list::String
  function StartAttributeTag(name,attribute_list)
    return Dict("start" => string("<",name, attribute_list,"/>"))
  end
end

# Example: <svg></svg> or <svg>content</svg>
struct StartEndTag
  name::String
  function StartEndTag(name)
    return Dict("start" => string("<",name,">"), "end" => string("</",name,">"))
  end
end

# Example: <svg/>
struct StartTag
  name::String
  function StartTag(name)
    return Dict("start" => string("<",name," />"))
  end
end

# Composite type for xml attributes
struct Attribute
  key::String
  value::String
  function Attribute(key,value)
     return string(" ",key,"=\"",value,"\"")
  end
end

# Composite type for core xml elements.
struct Xml
    name::String
    attributes::Dict
    children::Bool
    el::Dict
    function Xml(name::String,attributes::Dict=Dict(),hasChildren::Bool=false)
      if !isnothing(attributes)
         attribute_list = string()
         for a in keys(attributes)
           attribute_list = string(attribute_list, Attribute(a,attributes[a]))
         end
         el = hasChildren == true ? StartAttributesEndTag(name,attribute_list) : StartAttributeTag(name,attribute_list)
      else
         el = hasChildren == true ? StartEndTag(name) : StartTag(name)
      end
      return el
     end
  end

"""
Multiple dispatch: Wrapper functions for various use cases.

"""
# Create element without attributes and children. Default element name is: "xml"
function element(name::String="xml")
  return string(Xml(name)["start"])
end

# Create element without attributes but with children
function element(name::String,child::String)
  return string(Xml(name,Dict(),true)["start"], child, Xml(name,Dict(),true)["end"])
end

# Create element with attributes but without children
function element(name::String,attributes::Dict)
  return string(Xml(name,attributes)["start"])
end

# Create element with attributes and children
function element(name::String,attributes::Dict,child::String)
  return string(Xml(name,attributes,true)["start"], child, Xml(name,attributes,true)["end"])
end
