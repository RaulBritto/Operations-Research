module Simplex

using LinearAlgebra
using MathOptInterface
using JuMP

include("tableauSimplex.jl")
include("main.jl")
include("convertModel.jl")
include("dual.jl")


end # module
