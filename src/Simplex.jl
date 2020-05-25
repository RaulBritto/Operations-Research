module Simplex

using LinearAlgebra

greet() = print("Hello World!")

include("tableauSimplex.jl")

export tableauSimplex

end # module
