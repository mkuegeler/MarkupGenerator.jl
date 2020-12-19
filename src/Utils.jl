"""
================================================================================
# Generic support types and functions
================================================================================
"""

export read_file, get_json, PKG_ROOT_DIR, check_attributes, generate, join_str, set_random_id, show_dict, funcName, getFunc, get_attributes

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
                     # attributes = check_attributes(attributes,$default)
                     return !isempty(children) ? element($e,attributes,children) : element($e,attributes)
                   end
              export $fn
         end
       )
   end
 end

 # Helper function to join an array of strings into one string, i.e. viewBox attribute
 function join_str(args)
   chop(join(map(v -> string("$v "), args)),head = 0, tail = 1)
 end

 # Set random id values for elements.
 # Alphanumeric characters only because href values with numbers as the first character do not work in svg documents
 function set_random_id(l::Int64=8)
   Random.randstring('a':'z', l)
 end

 # Show key and values of a dictionary as a string list
 function show_dict(d::Dict)
   content = string()
   for (key,value) in sort(collect(d))
         content = (string(content, "- ", key," : ",value, "\n"))
     end
     return """
            $content
            """
 end

 # Return function name of the current function
 # Reference: https://discourse.julialang.org/t/how-to-print-function-name-and-source-file-line-number/43486
 macro funcName()
    quote
         st = stacktrace(backtrace())
         myf = ""
         for frm in st
             funcname = frm.func
             if frm.func != :backtrace && frm.func!= Symbol("macro expansion")
                 myf = frm.func
                 break
             end
         end
         string(myf)
     end
 end

 # turn string into functions
 function getFunc(name)
     fn = Symbol(name)
     eval(
        quote
            return $fn()
        end
     )
 end

 # Return a copy of a dict value
 function get_attributes(d::Dict, value::String)
   return(copy(d[value]))
 end
