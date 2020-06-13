function SensAnalysis(A, b, c, xb)
    nrows = size(A,1)
    cb = zeros(nrows)
    B =  zeros(nrows, nrows)

    for i=1:nrows
        B[:,i] = A[:,xb[i]]
        cb[i] = c[xb[i]]
    end
    
    S = inv(B)
    b_ = S*b
    shadowPrice = transpose(cb)*S

    println("\nDual:")
    for i = 1: length(shadowPrice)
        println("λ[", i, "] = ", round(shadowPrice[i], digits = 4))
    end


    v = Float64[-Inf, Inf]
    V = Array[]    
    println("Variação de restrições")
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

        println( round(b[i]+V[i][1], digits = 4), " <= b[",i,"] <= ", round(b[i]+V[i][2], digits = 4))
    end
    
end