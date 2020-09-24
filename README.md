# MarkupGenerator.jl

| Status | Coverage |
| :----: | :----: |
| [![Build Status](https://travis-ci.org/mkuegeler/MarkupGenerator.jl.svg?branch=master)](https://travis-ci.org/mkuegeler/MarkupGenerator.jl) | [![codecov.io](http://codecov.io/github/mkuegeler/MarkupGenerator.jl/coverage.svg?branch=master)](http://codecov.io/github/mkuegeler/MarkupGenerator.jl?branch=master) |

*A simple markup language generator*

This package provides a method to generate elements of a markup language. A markup language uses tags and attributes to define elements within a document.
The two most popular markup languages are HTML and XML.

The intent is to make it easier to create complex documents with parameters, like diagrams, animations and other visualizations.

"MarkupGenerator.jl" is written in the [Julia programming language](https://julialang.org).

The package is language-agnostic, meaning that elements and attributes of any markup language can be generated as long as they base on named elements and assigned attributes.

For instance, to create a **"svg"** element, all you need to do is typing:

```julia
el = element("svg")
```

Adding an attribute to the element:

```julia
attributes = Dict("id"=>"root")
el = element("svg",attributes)
println(el)
```

**"svg"** is the element name and **"id"** is just one attribute with value **"root"**.

```xml
<svg id="root"/>
```

Furthermore, you can add children elements. In doing so, it's easy to create a nested structure of elements.

```julia
rect_attributes = Dict("id"=>"my rectangle")
rect = element("rect",rect_attributes)

svg_attributes = Dict("id"=>"root")
el = element("svg",svg_attributes,rect)
println(el)
```

Here is the output:

```xml
<svg id="root"><rect id="my rectangle"></rect></svg>
```

## Using element libraries

The core of the package serves as an abstraction layer for language-specific representations like HTML,XML or SVG. Element libraries and their attributes with sample values in JSON format facilitate the generation of element compositions.
Basically, these libraries are invocable as JSON files or on a more generic level via API calls requiring a definition of a dedicated API respectively.

The following example shows the **svg** element of an SVG application and its attributes.
[SVG](https://www.w3.org/TR/SVG11/intro.html) stands for Scalable Vector Graphics and is an application of XML to create highly detailed, resolution-independent, two-dimensional images in a truly portable format.

The JSON file **"svg.json"** in directory "test" contains common SVG elements. By following the scheme of the file, any other markup language can be invoked in a similar manner.

Load the JSON file from the test directory:

```julia
SVG ="svg.json"
svg_attributes = get_json(SVG)["svg"]

```
Note: "get_json" is defined in "test/utils.jl".

Let's take a look at the svg element within the file:

```json
{
  "svg": {
    "style": "background-color:#cccccc;",
    "xmlns": "http://www.w3.org/2000/svg",
    "xmlns:xlink": "http://www.w3.org/1999/xlink",
    "preserveAspectRatio": "xMidYMid meet",
    "viewBox": "0 0 1282 721",
    "height": "100%",
    "width": "100%"
  },
}
```

You can use the predefined values of the element for your custom document. "get_json" transforms the JSON element into a Julia dictionary.

```julia
SVG ="svg.json"
svg_attributes = get_json(SVG)["svg"]
el = element("svg",svg_attributes)
println(el)
```

What you get is a SVG document with attributes and values from the JSON file.

```xml
<svg viewBox="0 0 1282 721" height="100%" style="background-color:#cccccc;" xmlns:xlink="http://www.w3.org/1999/xlink" preserveAspectRatio="xMidYMid meet" xmlns="http://www.w3.org/2000/svg" width="100%"/>
```
