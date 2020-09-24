using MarkupGenerator, Test

const ASSETS_DIR = joinpath(dirname(@__FILE__), "..", "assets")

# 1. Create element without name, attributes and children
@testset "element with no name, attributes and children" begin
    # Test value: an element name as string
    el = "xml"
    # Test expected output
    @test element() == string("<",el,"/>")
    println(element())


    # Test with integer value (only strings accepted)
    el = 1
    @test_throws MethodError element(el)
end

# 2. Create element without attributes and children
@testset "element with custom name but no attributes,children" begin
    # Test value: an element name as string
    el = "svg"
    # Test expected output
    @test element(el) == string("<",el,"/>")
    println(element(el))

    # Test with integer value (only strings accepted)
    el = 1
    @test_throws MethodError element(el)
end

# 3. Create element without attributes but with children
@testset "element with custom name, no attributes but with children" begin
    # Test values: an element name as string and a string as a nested element
    el = "svg"
    children = "content"
    # Test expected output
    @test element(el,children) == string("<",el,">",children,"</",el,">")
    println(element(el,children))

    # Reverse test with integer values (only strings accepted)
    el = 1
    children = 2
    @test_throws MethodError element(el,children)
end

# 4. Create element with attributes but without children
@testset "element with attributes but without children" begin
    # Test values: an element name as string and a string as a nested element
    el = "svg"
    key = "id"
    value = "root"
    attributes = Dict(key=>value)
    # Test expected output
    @test element(el,attributes) == string("<",el," ",key,"=\"",value,"\"/>")
    println(element(el,attributes))

    # Reverse test with integer value for attribute (Dict expected)
    attributes = 1
    @test_throws MethodError element(el,attributes)

end

# 5. Create element with attributes and children
@testset "element with custom name, attributes and children" begin
    # Test values: an element name as string and a string as a nested element
    el = "svg"
    key = "id"
    value = "root"
    children = "content"
    attributes = Dict(key=>value)
    # Test expected output
    @test element(el,attributes,children) == string("<",el," ",key,"=\"",value,"\">",children,"</",el,">")
    println(element(el,attributes,children))

    # Reverse test with integer value for attributes and children (Dict and string expected)
    attributes = 1
    children = Dict()
    @test_throws MethodError element(el,attributes,children)

end

# 6. Read attributes from JSON file
@testset "Read attributes values from JSON file" begin
    SVG = string(PKG_ROOT_DIR,"/assets/svg/","svg.json")
    a = Dict("href" => "#")

    @test get_json(SVG)["a"] == a
    println(get_json(SVG)["a"])

    SVG ="xyz.json"
    @test_throws MethodError get_json(SVG)["a"]


end

# 7. Read attributes from JSON file and use it as values for an element
@testset "Read attributes values from JSON file" begin
    SVG = string(PKG_ROOT_DIR,"/assets/svg/","svg.json")
    el = "defs"
    attributes = get_json(SVG)[el]
    result = "<defs/>"

    @test element(el,attributes) == result
    println(element(el,attributes))

    attributes = false

    @test_throws MethodError element(el,attributes)


end

# 8. Test generated svg elements
@testset "Test svg-specific elements" begin

    at = Dict("id" => "my rect")

    println(svg_rect())
    println(svg_rect(at))
    println(svg_rect(Dict(),"content"))
    println(svg_rect(at,"content"))



end

# 9. Test svg document function
@testset "Test svg document function" begin

   style = Cpnt(Dict(),svg_css(CSS))
   println(svg_document(Cpnt(),style,Cpnt(),Cpnt()))


end
