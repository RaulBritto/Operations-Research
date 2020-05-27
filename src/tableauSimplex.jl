function primalSolution(A, b, c, z, n)
    nrows = size(A,1)

    cl = -c
    xb = collect(n+1:n+nrows)
    tableau = [ [transpose(cl) ;A] [-z;b]]


    while true
        Z = tableau[1,:]
        if all(Z .>= 0)
            println("Solução ótima encontrada!")
            println(tableau)
            y = tableau[2:end, end]
            solution = [xb y]
            solution = solution[solution[:, 1] .<= size(A,2),:]
            solution = Dict(zip(string.("x",round.(Int,solution[:,1])), solution[:,2]))
            println(solution)
            println(Z[end])
            break
        else
            pivotColumnIndex = argmin(Z)
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

end