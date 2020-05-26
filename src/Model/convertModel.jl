function Model2Matriz(model::Model)
    n = num_variables(model)
    c = Array{Float64,1}()

    min_max = objective_sense(model)

    println(min_max)

    if occursin(print(min_max), "MIN") 
        println("minimizacao")
    else
        println("maximizacao")
    end


    for i = 1:n
        variables = all_variables(model)
        currentVariable = variables[i]

    end
end