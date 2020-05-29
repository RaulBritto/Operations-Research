function SensAnalysis(tableau, model::Model)
    nrows = size(tableau,1)-1
    shadowPrice = tableau[1,num_variables(model)+1:num_variables(model)+nrows]
    
    S = tableau[2:end,num_variables(model)+1:num_variables(model)+nrows]

    println("\nPreço sombra:")
    for i = 1: length(shadowPrice)
        println("restrição[", i, "] = ", shadowPrice[i])
    end

    
end