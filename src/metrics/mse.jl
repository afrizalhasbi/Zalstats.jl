
function mse(exp::AbstractVector{<:Number}, pred::AbstractVector{<:Number})
    @assert length(exp) == length(pred), "Vector lengths must be equal"
    (pred .- exp)^2 / length(exp)
end
