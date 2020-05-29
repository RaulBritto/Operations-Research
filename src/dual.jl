using MathOptInterface

function dual(model::Model,b)

    dualModel = Model()
    index = 1
    A_ = Array{Float64}(undef, 0, num_variables(model))
    c_ = Array{Float64,1}()
    restriction = reshape(zeros(Float64,num_variables(model)), 1, num_variables(model))

    #Setting the variables
    constraints = all_constraints(model, AffExpr, MOI.LessThan{Float64})
    if length(constraints) > 0
        @variable(dualModel,[index:num_constraints(model, AffExpr, MOI.LessThan{Float64})], base_name="y", lower_bound = 0 )
        index += num_constraints(model, AffExpr, MOI.LessThan{Float64})
    end

    constraints = all_constraints(model, AffExpr, MOI.EqualTo{Float64})
    if length(constraints) > 0
        @variable(dualModel,[index:index-1+num_constraints(model, AffExpr, MOI.EqualTo{Float64})], base_name="y")
        index += num_constraints(model, AffExpr, MOI.EqualTo{Float64})
    end

    constraints = all_constraints(model, AffExpr, MOI.GreaterThan{Float64})
    if length(constraints) > 0
        @variable(dualModel,[index:index-1+num_constraints(model, AffExpr, MOI.GreaterThan{Float64})], base_name="y", upper_bound = 0)
        index += num_constraints(model, AffExpr, MOI.GreaterThan{Float64})
    end

    #Setting objective_function
    set_objective_sense(dualModel, MOI.MIN_SENSE)
    variables = all_variables(dualModel)

    for i=1:num_variables(dualModel)
        set_objective_coefficient(dualModel,variables[i], Base.convert(Float64,b[i]))
    end


    #Setting the constraints
    variables = all_variables(model)
    for i=1:num_variables(model)
        
    end

    constraints = all_constraints(model, AffExpr, MOI.LessThan{Float64})
    for i=1:num_constraints(model, AffExpr, MOI.LessThan{Float64})
        for j=1:num_variables(model)
            restriction[j] = normalized_coefficient(constraints[i],variables[j])    
        end
        A_ = vcat(A_,restriction)
    end

    constraints = all_constraints(model, AffExpr, MOI.EqualTo{Float64})
    for i=1:num_constraints(model, AffExpr, MOI.EqualTo{Float64})
        for j=1:num_variables(model)
            restriction[j] = normalized_coefficient(constraints[i],variables[j])    
        end
        A_ = vcat(A_,restriction)
    end

    constraints = all_constraints(model, AffExpr, MOI.GreaterThan{Float64})
    for i=1:num_constraints(model, AffExpr, MOI.GreaterThan{Float64})
        for j=1:num_variables(model)
            restriction[j] = normalized_coefficient(constraints[i],variables[j])    
        end
        A_ = vcat(A_,restriction)
    end

    A_ = transpose(A_)

    min_max = Int8(objective_sense(model))
    if min_max == 0
        objective = objective_function(model)*-1
    elseif min_max == 1
        objective = objective_function(model)
    end

    variables = all_variables(model)
    variablesDual = all_variables(dualModel)
    for i=1:num_variables(model)
        if has_lower_bound(variables[i])
            @constraint(dualModel, variablesDual[i] >= objective.terms[variables[i]])
            constraints = all_constraints(dualModel, AffExpr, MOI.GreaterThan{Float64})
            for j=1:num_variables(dualModel)
                set_normalized_coefficient(constraints[end], variablesDual[j] , A_[i,j])
            end
       end

       if has_upper_bound(variables[i])
            @constraint(dualModel, variablesDual[i] <= objective.terms[variables[i]])
            constraints = all_constraints(dualModel, AffExpr, MOI.GreaterThan{Float64})
            for j=1:num_variables(dualModel)
                set_normalized_coefficient(constraints[end], variablesDual[j] , A_[i,j])
            end
       end

       if !has_upper_bound(variables[i]) & !has_lower_bound(variables[i])
            @constraint(dualModel, variablesDual[i] == objective.terms[variables[i]])
            constraints = all_constraints(dualModel, AffExpr, MOI.GreaterThan{Float64})
            for j=1:num_variables(dualModel)
                set_normalized_coefficient(constraints[end], variablesDual[j] , A_[i,j])
            end
        end
    end

    println("\nDual Model:\n",dualModel)
end