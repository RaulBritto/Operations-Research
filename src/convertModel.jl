using LinearAlgebra

function Model2Matriz(model::Model)

    c = Array{Float64,1}()
    b = Array{Int64,1}()
    A = Array{Int64}(undef, 0, num_variables(model))
    restriction = reshape(zeros(num_variables(model)), 1, num_variables(model))

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


    for i=1:num_variables(model)

        if has_lower_bound(variables[i])
            if lower_bound(variables[i]) == 0
                if has_upper_bound(variables[i])
                    append!(b,upper_bound(variables[i]))
                    restriction[i] = 1
                    A = vcat(A,restriction)
                    restriction[i] = 0
                end
            else
                #TODO new lower_bound to 0
            end
        else
            #TODO create lower_bound
        end
    end
    
    constraints = all_constraints(model, AffExpr, MOI.LessThan{Float64})
    for i=1:num_constraints(model, AffExpr, MOI.LessThan{Float64})
        restriction = reshape(zeros(num_variables(model)), 1, num_variables(model))
        for j=1:num_variables(model)
            restriction[j] = normalized_coefficient(constraints[i],variables[j])    
        end
        A = vcat(A,restriction)
        append!(b,normalized_rhs(constraints[i]))
        append!(c,0)
    end
    A = hcat(A, Matrix{Int64}(I, num_constraints(model, AffExpr, MOI.LessThan{Float64}), num_constraints(model, AffExpr, MOI.LessThan{Float64})))
 
    return A,b,c
end
