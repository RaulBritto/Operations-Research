# Simplex

This repository has the implementation of the tableau simplex algorithm made during the Master degree at UFPB.

The simplex algorithm has been developed using Julia lang version 1.4.1 (2020-04-14) and models are created using [JuMP](https://www.juliaopt.org/JuMP.jl/stable/). To install the Simplex package use the follow command from Julia REPL:

```julia
(@v1.4) pkg> add https://github.com/RaulBritto/Operations-Research.git
```

##

To create a new model to be optimized using JuMP macros

```julia
using JuMP

model = Model()

@variable(model, x1 >=0)
@variable(model, x2 >= 0)
@objective(model, Max, 3x1 + 5x2)
@constraint(model, x1 <= 4)
@constraint(model, 2x2 <= 12)
@constraint(model, 3x1 + 2x2 <= 18)
```
To solve the problem use the follow command:
```julia
Simplex.main(model)
