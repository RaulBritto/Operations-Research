"""
Single variable bound constraints
"""
# MOI.supports_constraint(::Optimizer, ::Type{SVF}, ::Type{AbstractVector{<:MOI.AbstractScalarSet}}) = true
MOI.supports_constraint(
    ::Optimizer, 
    ::Type{SVF}, 
    ::Type{MOI.LessThan{T}}
) where {T<:Real} = true

MOI.supports_constraint(
    ::Optimizer,
    ::Type{SVF},
    ::Type{MOI.GreaterThan{T}},
) where {T<:Real} = true

MOI.supports_constraint(
    ::Optimizer,
    ::Type{SVF}, 
    ::Type{MOI.EqualTo{T}}
) where {T<:Real} = true

MOI.supports_constraint(
    ::Optimizer,
    ::Type{SVF}, 
    ::Type{MOI.Interval{T}}
) where {T<:Real} = true


MOI.supports_constraint(
    ::Optimizer,
    ::Type{SVF},
    ::Type{Integers},
) = true

"""
Binary/Integer variable support
"""
MOI.supports_constraint(::Optimizer, ::Type{SVF}, ::Type{<:VAR_TYPES}) = true



"""
    MOI.add_variable(model::Optimizer)
"""
function MOI.add_variable(model::Optimizer)
    index = length(model.variable_info) + 1
    push!(model.variable_info, Variable(index))
    changes = changes = Vector{Vector{Tuple{Symbol,Int,Int,Int}}}()
    push!(changes, Vector{Tuple{Symbol,Int,Int,Int}}())
    model.variable_info[index].changes = changes
    push!(model.inner.subscription, Int[])
    push!(model.inner.bt_infeasible, 0)
    addupd_var_in_inner_model(model, index)
    return MOI.VariableIndex(index)
end