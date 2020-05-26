using Simplex

function main(model::Model)
    
    A,b,c = Simplex.Model2Matriz(model)
    println(A)
    println(b)
    println(c)
    Simplex.tableauSimplex(A,b,c)

end
