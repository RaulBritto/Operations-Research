function optimize(A, b, c, z, n)
    nrows = size(A,1)
    xb = collect(n+1:n+nrows)
    tableau = [ [transpose(-c) ;A] [-z;b]]


    while true
        Z = tableau[1,:]
        if all(Z[1:end-1] .>= 0)
            println("Solução ótima encontrada!")
            y = tableau[2:end, end]
            solution = [xb y]
            solution = solution[solution[:, 1] .<= size(A,2),:]
            solution = Dict(zip(string.("x",round.(Int,solution[:,1])), round.(solution[:,2], digits=4)))
            println("Z = ", round(Z[end], digits=4))
            println("Solução básica: \n",solution)
            break
        else
            pivotColumnIndex = argmin(Z[1:end-1])
            pivotColumn = tableau[2:end, pivotColumnIndex]
            costs = []
            for (index, value) in enumerate(pivotColumn)
                if pivotColumn[index] > 0
                    append!(costs, tableau[1+index,end] / value)
                else 
                    append!(costs,Inf)
                end
            end

            if isempty(filter((x) -> !isinf(x), costs))
                println("Solução ilimitada!")
                break
            end 

            pivotRowIndex = argmin(costs)
            pivotRow = tableau[pivotRowIndex+1, :]
            pivotRow = pivotRow ./ pivotRow[pivotColumnIndex]
    
            for i = 1:size(tableau,1)
                if pivotRowIndex+1 != i
                    if tableau[i, pivotColumnIndex] > 0
                        tableau[i, :] -= tableau[i, pivotColumnIndex] .* pivotRow
                    elseif tableau[i, pivotColumnIndex] < 0
                        tableau[i, :] += abs(tableau[i, pivotColumnIndex]) .* pivotRow
                    end
                else
                    tableau[pivotRowIndex+1, :] = pivotRow
                end
            end
            
            xb[pivotRowIndex] = pivotColumnIndex
        end
    end

    return  tableau, xb
end