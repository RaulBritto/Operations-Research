function primalSolution(A, b, c)
    nrows = size(A,1)

    cl = [-c; zeros(nrows)]
    xb = collect(nrows: 2*nrows-1)
    tableau = [ [transpose(cl) ;A I] [0;b]]


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
            costs = tableau[2:end, end] ./ pivotColumn
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