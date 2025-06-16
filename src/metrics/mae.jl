
function mae(exp::AbstractVector{<:Number}, pred::AbstractVector{<:Number})
    @assert length(exp) == length(pred), "Vector lengths must be equal"
    return abs(pred .- exp) / length(exp)
end
