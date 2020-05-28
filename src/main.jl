using Simplex

function main(model::Model)
    
    A,b,c,z = Simplex.Model2Matriz(model)
    #println(A)
    #println(b)
    #println(c)
    Simplex.primalSolution(A,b,c,z,num_variables(model))
    dual = Simplex.dual(model,b)

end
