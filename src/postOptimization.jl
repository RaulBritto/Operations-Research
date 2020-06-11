function SensAnalysis(tableau, model::Model)
    nrows = size(tableau,1)-1
    shadowPrice = tableau[1,num_variables(model)+1:num_variables(model)+nrows]
    
    S = tableau[2:end,num_variables(model)+1:num_variables(model)+nrows]
    b_ = tableau[2:end, end]

    println("\nDual:")
    for i = 1: length(shadowPrice)
        println("restrição[", i, "] = ", shadowPrice[i])
    end

    v = Float64[-Inf, Inf]
    V = Array[]    
    for i = 1:nrows
        push!(V,copy(v))
        delta = zeros(nrows)
        delta[i] = 1
        x = -b_./(S*delta)
        for j = 1:nrows
            if S[j,i] > 0 && V[i][1] < x[j]
                V[i][1] = x[j]
            elseif S[j,i] < 0 && V[i][2] > x[j]
                V[i][2] = x[j]
            end
        end
        replace!(V[i], Inf=>0)
        replace!(V[i], -Inf=>0)

        println(b[i]-V[i][1]" <= b[",i,"] <= ", b[i]+V[i][2])
    end
    
end