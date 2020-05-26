function Model2Matriz(model::Model)

    c = Array{Float64,1}()

    min_max = Int8(objective_sense(model))

    if min_max == 0
        objective = objective_function(model)*-1
    elseif min_max == 1
        objective = objective_function(model)
    end

    variables = all_variables(model)
    for i=1:num_variables(model)
       append!(c,objective.terms[variables[i]])
    end

    println(c)    
    


end
