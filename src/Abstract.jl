"""
# abstract.jl

A collection of geometrical data types
==============================================================
Author: Michael Kuegeler
Email: mkuegeler@mac.com
Date: 17.5.2020
==============================================================

## About
This script comprises a collection of data types, related to generic two-dimensional geometries.
The intend is to provide a set of data types which facilitate the creation of parametric graphics.

The script is structured into these sections:

## Section 1: Essential data types
## Section 2: Composite data types

"""

"""
==============================================================

# Section 1: Essential data types
==============================================================
"""

# default digits
global d = 3

"""
Abstract point definition.
fields: x,y,z coordinates
"""

mutable struct Point
   x::Float64
   y::Float64
   z::Float64 # z is optional
    function Point(x,y,z::Float64=0.0)
        new(Float64(x, RoundUp) , Float64(y, RoundUp) , Float64(z, RoundUp))
    end
end

"""
Abstract line definition.
fields: start and end point (type of point is previously defined Point)
"""

mutable struct Line
   p1::Point
   p2::Point
    function Line(p1,p2)
        new(p1, p2)
    end
end

"""
Raw rectangle
"""

# Rectangle support function: Calculation of coordinates, depending on inion point
function get_rectangle_points(p0::Point,w::Float64,h::Float64)
    # clock wise direction
    # p0 = top left (default)
    p1 = Point((p0.x+(w/2)),p0.y) # mid top
    p2 = Point((p0.x+w),p0.y) # top right
    p3 = Point((p0.x+w),(p0.y+(h/2))) # mid right
    p4 = Point((p0.x+w),(p0.y+h)) # buttom right
    p5 = Point((p0.x+(w/2)),(p0.y+h)) # mid buttom
    p6 = Point(p0.x,(p0.y+h)) # buttom left
    p7 = Point(p0.x,(p0.y+(h/2))) # mid left
    p8 = Point((p0.x+(w/2)),(p0.y+(h/2))) # center

    Dict("tl"=>p0,"mt"=>p1,"tr"=>p2,"mr"=>p3,"br"=>p4,"mb"=>p5,"bl"=>p6,"ml"=>p7,"cp"=>p8)
end


mutable struct Rectangle
    in::Point # in point of rectangle
    w::Float64 # w
    h::Float64 # h
    start::Int64 # indicates the location of inion point
    # 0 = top left (default) 1 = top right, 2 = buttom right, 3 = buttom left, 4 = center
    points::Dict # Dict with all four edge points of the rectangle plus center point
    r::Float64 # maximum value of a radius within the rectangle, depends on w and h
    function Rectangle(in::Point=Point(0.0,0.0,0.0),w::Float64=100.0,h::Float64=100.0,start::Int64=0)
        r = w >= h ? (h/2) : (w/2)
        if start == 1 # inion: top right
            p = Point((in.x-w),in.y)
        elseif start == 2 # inion: buttom right
            p = Point( (in.x-w),(in.y-h) )
        elseif start == 3 # inion: buttom left
            p = Point(in.x, (in.y+h) )
        elseif start == 4 # inion: center
            p = Point( (in.x-(w/2) ) ,(in.y-(h/2)) )
        else # default
            p = in
        end
        points = get_rectangle_points(p,w,h)

        new(in, w, h, start, points, r)
    end
end

# Wrapper function for struct Rectangle: Convert string values to Float64 and returns a tuple

# Call with default variables

function abstract_rectangle()
        rect = Rectangle()
        points  = Dict()
        for (key,value) in rect.points
            push!(points, key => (x=string(value.x), y=string(value.y), z=string(value.z)))
        end
        (w=string(rect.w), h=string(rect.h), points=points, r=string(rect.r))
end
# x,y,w,h,start
function abstract_rectangle(at::Dict)
        x,y,w,h,start = at["x"],at["y"],at["w"],at["h"],at["start"]
        # We may get the values as different types, so let's convert them first into strings
        # Next, convert them into types required by the Rectangle composite
        p = map(v -> parse(Float64, v), map(v -> string(v), [x,y,w,h]))
        rect = Rectangle(Point(p[1],p[2]),p[3],p[4],parse(Int64, string(start)))

        points  = Dict()
        for (key,value) in rect.points
            push!(points, key => (x=string(value.x), y=string(value.y), z=string(value.z)))
        end
        (w=string(rect.w), h=string(rect.h), points=points, r=string(rect.r))
end


"""
Abstract ScaleneTriangle
A scalene triangle has all its sides of different lengths

Other types are:
By lengths of sides: Equilateral, Isosceles

By internal angles: Right, Obtuse, Acute


"""
mutable struct ScaleneTriangle
    pa::Point
    pb::Point
    pc::Point
    function ScaleneTriangle(pa,pb,pc)

        new(pa, pb, pc)
    end

end



"""
==============================================================

# Section 2: Composite data types
==============================================================
"""

"""
# Abstract Grid
"""

mutable struct Grid
    in::Point
    nx::UInt16
    ny::UInt16
    w::Float64
    h::Float64
    f::UInt16
    grid::Array{Line,1}
    function Grid(in=Point(0.0,0.0,0.0), nx=5, ny=5,  w=100.0, h=100.0, f=1)
        # if factor f is larger or equal to either nx or ny, set f to 1
        f = (f >= nx || f >= ny) ? 1 : f

        grid = Line[]

        for i= 1:(nx-f)

            x1 = round( (in.x+((w/nx)*i)), digits=d)
            y1 = round(in.y, digits=d)

            x2 = round((in.x+((w/nx)*i)),digits=d)
            y2 = round((in.y+h), digits=d)

            push!(grid, Line(Point(x1,y1),Point(x2,y2)))

        end

        for j= 1:(ny-f)

            x1 = round(in.x, digits=d)
            y1 = round((in.y+((h/ny)*j)), digits=d)

            x2 = round((in.x+w),digits=d)
            y2 = round((in.y+((h/ny)*j)), digits=d)

            push!(grid, Line(Point(x1,y1),Point(x2,y2)))

        end

        new(in, nx, ny, w, h, f, grid)
    end

end

# Wrapper for Grid
function abstract_grid()
    g = Grid()
    lines  = Array{Any,1}()
    for l in g.grid
         push!(lines, (x1=string(l.p1.x), y1=string(l.p1.y), x2=string(l.p2.x), y2=string(l.p2.y)))
    end
    (x=string(g.in.x), y=string(g.in.y),nx=string(g.nx), ny=string(g.ny), w=string(g.w), h=string(g.h), lines=lines,f=string(g.f) )
end

function abstract_grid(at::Dict)
    x,y,nx,ny,w,h,f = at["x"],at["y"],at["nx"],at["ny"],at["w"],at["h"],at["f"]
    p = map(v -> parse(Float64, v), map(v -> string(v), [x,y,w,h]))
    nx,ny = parse(Int16,string(nx)),parse(Int16,string(ny))
    g = Grid(Point(p[1],p[2]),nx,ny,p[3],p[4],parse(Int16,string(f)))

    lines  = Array{Any,1}()
    for l in g.grid
         push!(lines, Dict("x1"=>string(l.p1.x), "y1"=>string(l.p1.y),"x2"=>string(l.p2.x), "y2"=>string(l.p2.y)))
    end
    (x=string(g.in.x), y=string(g.in.y),nx=string(g.nx), ny=string(g.ny), w=string(g.w), h=string(g.h), lines=lines,f=string(g.f) )
end

"""
Abstract NodeGrid
"""

mutable struct NodeGrid
    in::Point # inion: top left
    nx::UInt16
    ny::UInt16
    w::Float64
    h::Float64
    f::UInt16
    nodes::Array{Point,1}
    function NodeGrid(in=Point(0.0,0.0,0.0), nx=5, ny=5,  w=100.0, h=100.0, f=1)
        # if factor f is larger or equal to either nx or ny, set f to 1
        f = (f >= nx || f >= ny) ? 1 : f
        nodes = Point[]
        for j= 1:(ny-f)
           for i= 1:(nx-f)
             x = round((in.x+((w/nx)*i)), digits=d)
             y = round((in.y+((h/ny)*j)), digits=d)
             push!(nodes, Point(x,y))
           end
        end
        new(in, nx, ny, w, h, f, nodes)
    end

end

# Wrapper for NodeGrid
function abstract_nodegrid()
    n = NodeGrid()
    points  = Array{Any,1}()
    for e in n.nodes
        push!(points, Dict("x"=>string(e.x), "y"=>string(e.y)))

    end
    (x=string(n.in.x), y=string(n.in.y), w=string(n.w), h=string(n.h), points=points, f=string(n.f))
end

function abstract_nodegrid(at::Dict)
    x,y,nx,ny,w,h,f = at["x"],at["y"],at["nx"],at["ny"],at["w"],at["h"],at["f"]
    p = map(v -> parse(Float64, v), map(v -> string(v), [x,y,w,h]))
    nx,ny = parse(Int16,string(nx)),parse(Int16,string(ny))
    n = NodeGrid(Point(p[1],p[2]),nx,ny,p[3],p[4],parse(Int16,string(f)))
    points  = Array{Any,1}()
    for e in n.nodes
        push!(points, Dict("x"=>string(e.x), "y"=>string(e.y), "z"=>string(e.z)))

    end
    (x=string(n.in.x), y=string(n.in.y), w=string(n.w), h=string(n.h), points=points, f=string(n.f))
end


"""
Abstract PanelGrid
nx,ny,in::Point,w,h,of
in, nx, ny,  w, h, f
"""

mutable struct PanelGrid
    in::Point # inion: top left
    nx::UInt16
    ny::UInt16
    w::Float64
    h::Float64
    of::Float64
    panels::Array{Rectangle,1}
    function PanelGrid(in=Point(0.0,0.0,0.0), nx=5, ny=5,  w=100.0, h=100.0, of=1.0)
        # if of is larger or equal to either panel w or panel h, set of to 0
        of = (of >= (w/nx) || of >= (h/ny)) ? 0 : of

        panels = Rectangle[]

        x = round((in.x+(of/2)), digits=d)
        y = round((in.y+(of/2)), digits=d)

        x1 = x
        y1 = y

        for j= 1:ny
            for i= 1:nx
               push!(panels, Rectangle(Point(x1,y1),round(((w/nx)-of), digits=d),round(((h/ny)-of), digits=d)))
               x1 = round(((in.x+(of/2))+((w/nx)*i)), digits=d)
            end
            x1 = round((in.x+(of/2)),digits=d)
            y1= round(((in.y+(of/2))+((h/ny)*j)), digits=d)
        end

        new(in, nx, ny, w, h, of, panels)
    end

end

# Wrapper function PanelGrid
function abstract_panelgrid()
    g = PanelGrid()
    panels  = Array{Any,1}()
    for r in g.panels
        push!(panels, Dict("x"=>string(r.in.x), "y"=>string(r.in.y), "w"=>string(r.w), "h"=>string(r.h), "points"=>r.points))
    end
    (x=string(g.in.x), y=string(g.in.y), w=string(g.w), h=string(g.h), panels=panels, of=string(g.of))
end

function abstract_panelgrid(at::Dict)
    x,y,nx,ny,w,h,of = at["x"],at["y"],at["nx"],at["ny"],at["w"],at["h"],at["of"]
    p = map(v -> parse(Float64, v), map(v -> string(v), [x,y,w,h,of]))
    nx,ny = parse(Int16,string(nx)),parse(Int16,string(ny))

    g = PanelGrid(Point(p[1],p[2]),nx,ny,p[3],p[4],p[5])
    panels  = Array{Any,1}()
    for r in g.panels
        push!(panels, Dict("x"=>string(r.in.x), "y"=>string(r.in.y), "w"=>string(r.w), "h"=>string(r.h), "r"=>string(r.r), "points"=>r.points))
    end
    (x=string(g.in.x), y=string(g.in.y), w=string(g.w), h=string(g.h), panels=panels, of=string(g.of))
end
