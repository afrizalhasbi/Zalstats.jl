include("variance.jl")

function stdev(a::AbstractVector{<:Real})
    return sqrt(variance(a))
end

# assumes the number represents variance
function stdev(a::Real)
    return sqrt(a)
end
