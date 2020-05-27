using Simplex

function main(model::Model)
    
    A,b,c = Simplex.Model2Matriz(model)
    #println(A)
    #println(b)
    #println(c)
    Simplex.primalSolution(A,b,c, num_variables(model))

end
