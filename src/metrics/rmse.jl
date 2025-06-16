include("mse.jl")

function rmse(exp::AbstractVector{<:Number}, pred::AbstractVector{<:Number})
    @assert length(exp) == length(pred), "Vector lengths must be equal"
    sqrt(mse(exp, pred))
end
