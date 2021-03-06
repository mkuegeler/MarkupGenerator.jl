using MarkupGenerator, Test, Random

const ASSETS_DIR = joinpath(dirname(@__FILE__), "..", "assets")

# 1. Create element without name, attributes and children
# @testset "element with no name, attributes and children" begin
#     # Test value: an element name as string
#     el = "xml"
#     # Test expected output
#     @test element() == string("<",el,"/>")
#     println(element())
#
#
#     # Test with integer value (only strings accepted)
#     el = 1
#     @test_throws MethodError element(el)
# end
#
# # 2. Create element without attributes and children
# @testset "element with custom name but no attributes,children" begin
#     # Test value: an element name as string
#     el = "svg"
#     # Test expected output
#     @test element(el) == string("<",el,"/>")
#     println(element(el))
#
#     # Test with integer value (only strings accepted)
#     el = 1
#     @test_throws MethodError element(el)
# end
#
# # 3. Create element without attributes but with children
# @testset "element with custom name, no attributes but with children" begin
#     # Test values: an element name as string and a string as a nested element
#     el = "svg"
#     children = "content"
#     # Test expected output
#     @test element(el,children) == string("<",el,">",children,"</",el,">")
#     println(element(el,children))
#
#     # Reverse test with integer values (only strings accepted)
#     el = 1
#     children = 2
#     @test_throws MethodError element(el,children)
# end
#
# # 4. Create element with attributes but without children
# @testset "element with attributes but without children" begin
#     # Test values: an element name as string and a string as a nested element
#     el = "svg"
#     key = "id"
#     value = "root"
#     attributes = Dict(key=>value)
#     # Test expected output
#     @test element(el,attributes) == string("<",el," ",key,"=\"",value,"\"/>")
#     println(element(el,attributes))
#
#     # Reverse test with integer value for attribute (Dict expected)
#     attributes = 1
#     @test_throws MethodError element(el,attributes)
#
# end
#
# # 5. Create element with attributes and children
# @testset "element with custom name, attributes and children" begin
#     # Test values: an element name as string and a string as a nested element
#     el = "svg"
#     key = "id"
#     value = "root"
#     children = "content"
#     attributes = Dict(key=>value)
#     # Test expected output
#     @test element(el,attributes,children) == string("<",el," ",key,"=\"",value,"\">",children,"</",el,">")
#     println(element(el,attributes,children))
#
#     # Reverse test with integer value for attributes and children (Dict and string expected)
#     attributes = 1
#     children = Dict()
#     @test_throws MethodError element(el,attributes,children)
#
# end
#
# # 6. Read attributes from JSON file
# @testset "Read attributes values from JSON file" begin
#     svg_json = get_json(string(PKG_ROOT_DIR,"/assets/svg/","svg.json"))
#     a = Dict("href" => "#")
#
#     @test svg_json["a"] == a
#     println(svg_json["a"])
#
#     svg_json = get_json(string(PKG_ROOT_DIR,"/assets/svg/","xyz.json"))
#     @test_throws MethodError get_json(svg_json)["a"]
#
#
# end
#
# # 7. Read attributes from JSON file and use it as values for an element
# @testset "Read attributes values from JSON file" begin
#     svg_json = get_json(string(PKG_ROOT_DIR,"/assets/svg/","svg.json"))
#     el = "defs"
#     attributes = svg_json[el]
#     result = "<defs/>"
#
#     @test element(el,attributes) == result
#     println(element(el,attributes))
#
#     attributes = false
#
#     @test_throws MethodError element(el,attributes)
#
#
# end
#
# # 8. Test generated svg elements
# @testset "Test svg-specific elements" begin
#
#     at = Dict("id" => "my rect")
#
#     println(svg_rect())
#     println(svg_rect(at))
#     println(svg_rect(Dict(),"content"))
#     println(svg_rect(at,"content"))
#
#
#
# end
#
# # 9. Test svg document function
# @testset "Test svg document function" begin
#
#     mydoc = SvgContent()
#     # mydoc.style = svg_style(Dict("id"=>"mystyles"),svg_css(CSS))
#     # mydoc.main = svg_g(Dict("id"=>"main"),svg_rect())
#
#     # println(svg_document(Dict("id"=>"root"),mydoc))
#
# end
#
# # 10. Test gradient element
# @testset "Test gradient element" begin
#
#     myrad = GradientContent()
#     myrad.stop1 = svg_stop(Dict("stop-color"=>"#ffffff"))
#
#     # println(radialGradient_template(Dict("id"=>"myrad"),myrad))
#     # println(linearGradient_template(Dict("id"=>"myrad"),myrad))
#
# end
#
# # 11. Test viewBox attribute
# @testset "Test viewBox attribute" begin
#
#     a = [0.0,0.0,100.34,200.55]
#     r = string("0.0 0.0 100.34 200.55")
#
#     @test join_str(a) == r
#     # println(join_str(a))
#
# end
#
# # 12. Test id assignments for styles
# @testset "Test create complete sample svg document" begin
#
#     #  Common parameters
#     x = 0
#     y = 0
#     width = 800
#     height = 600
#
#     my_rad_id = set_random_id()
#     myrad = GradientContent()
#     myrad.stop1 = svg_stop(Dict("stop-color"=>"#ffcc00", "offset"=>"10%"))
#     myrad.stop2 = svg_stop(Dict("stop-color"=>"#0000ff", "offset"=>"100%"))
#     rad = radialGradient_template(Dict("id"=>my_rad_id),myrad)
#
#
#     my_rect_style_id = set_random_id()
#
#     my_rect_style = CSS["rect"]
#     my_rect_style["fill"] = set_href(my_rad_id)
#     my_rect_style_el = svg_class("rect",my_rect_style,my_rect_style_id)
#     println(my_rect_style_el)
#
#     my_rect_attributes = SVG["rect"]
#     # # Delete style attribute because we use class instead
#     delete!(my_rect_attributes, "style")
#
#     my_rect_attributes["class"] = my_rect_style_id
#     my_rect_attributes["x"] = string(x)
#     my_rect_attributes["y"] = string(y)
#     my_rect_attributes["width"] = string(width)
#     my_rect_attributes["height"] = string(height)
#     my_rect = svg_rect(my_rect_attributes)
#
#
#
#     mydoc = SvgContent()
#
#     mydoc.style = svg_style(Dict(),svg_css([my_rect_style_el]))
#
#     mydoc.defs = svg_defs(Dict("id"=>"defs"),rad)
#     mydoc.main = svg_g(Dict("id"=>"main"), my_rect)
#
#     my_svg_attributes = SVG["svg"]
#     my_svg_attributes["viewBox"] = join_str([x,y,width,height])
#
#     println(svg_document(Dict("id"=>"root"),mydoc))
#
#
# end

# 13. Test doc recipe
@testset "Test doc recipe" begin

    params = get_attributes(RCP,"svg_doc_recipe")

    params["w"] = "800"
    params["h"] = "800"
    println(svg_doc_recipe(params))

end


# 14. Test canvas recipe
@testset "Test canvas recipe" begin
    params = get_attributes(RCP,"svg_canvas_recipe")

    # println(params)

    params["w"] = "800"
    params["h"] = "800"
    params["factor"] = "8"
    params["line_class"] = "no"
    params["circle_class"] = "no"
    params["rect_class"] = "yes"
    println(svg_canvas_recipe(params))
end
