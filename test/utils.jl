"""
================================================================================
# Helper functions
================================================================================
"""


export read_file,write_file,get_json,set_json

# read string from file
function read_file(name::String)
  content = string()
  if isfile(name) == true
    content = open(name) do file
     read(file, String)
    end
  else content = false
  end
  content
end

# write to a file.
function write_file(name,content)
   file = open(name, "w")
   write(file,content)
   close(file)
 end

 # Get dict from json file
 function get_json(file::String)
   read_file(file) != false ? JSON.parse(read_file(file)) : false
 end

 # Convert dict into a json string
 function set_json(d::Dict)
   JSON.json(d)
 end
