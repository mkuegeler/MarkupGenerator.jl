"""
================================================================================
# Generic support types and functions
================================================================================
"""

export read_file, get_json, PKG_ROOT_DIR, check_attributes, generate

# read string from file
function read_file(name::String)
  content = string()
  if isfile(name) == true
    content = open(name) do file
     read(file, String)
    end
  else content = false
  end
  return content
end

 # Get dict from json file
 function get_json(file::String)
   read_file(file) != false ? JSON.parse(read_file(file)) : false
 end

 # Check for mandatory attributes
 function check_attributes(attributes::Dict,default_attributes::Dict)
       for key in keys(default_attributes)
           attributes[key] = haskey(attributes,key) ? attributes[key] : default_attributes[key]
       end
       return attributes
 end

 # Generate functions for language-specific elements
 function generate(lib::Dict,pref::String=string())
   for (e,v) in lib
       # Prefix is optional, so if no prefix is given, just use the element name
       name = !isempty(pref) ? string(pref,e) : e
       fn = Symbol(name)
       default = !isempty(v) ? v : Dict()
       eval(
         quote
              $fn = function (attributes::Dict=$default,children::String=string())
                     attributes = check_attributes(attributes,$default)
                     return !isempty(children) ? element($e,attributes,children) : element($e,attributes)
                   end
              export $fn
         end
       )
   end
 end
