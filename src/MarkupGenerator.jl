module MarkupGenerator

import JSON
export PKG_ROOT_DIR

const PKG_ROOT_DIR = normpath(joinpath(@__DIR__, ".."))

include("./Utils.jl")
include("./Markup.jl")
include("./SVG.jl")

end # end of module
