using Simplex

function main(model::Model)
    
    A,b,c,z = Simplex.convert(model)
    tableau = Simplex.optimize(A,b,c,z,num_variables(model))
    Simplex.SensAnalysis(tableau, model)
    Simplex.dual(model,b)

end
