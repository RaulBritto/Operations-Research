using Simplex

function main(model::Model)
    
    A,b,c,z = Simplex.convert(model)
    tableau, xb = Simplex.optimize(A,b,c,z,num_variables(model))
    Simplex.SensAnalysis(A, b, c, xb)
    Simplex.dual(model,b)

end
