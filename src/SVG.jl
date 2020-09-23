"""
================================================================================
# SVG specific types and functions
================================================================================
"""

# Get default elements and attributes
const SVG = get_json(string(PKG_ROOT_DIR,"/assets/","svg.json"))

"""
A unique differenciator can be used for elements.
Example: "svg_rect"

"""

# Run main function to create functions based on the SVG JSON file
generate(SVG,"svg")
