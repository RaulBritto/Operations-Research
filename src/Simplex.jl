module Simplex

using LinearAlgebra
using MathOptInterface
using JuMP

include("tableauSimplex.jl")
include("main.jl")
include("convertModel.jl")
include("dual.jl")
include("postOptimization.jl")


end # module
