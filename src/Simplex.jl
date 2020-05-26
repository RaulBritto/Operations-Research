module Simplex

using LinearAlgebra
using MathOptInterface
using JuMP

include("tableauSimplex.jl")
include("main.jl")
include("Model/convertModel.jl")


end # module
