include("variance.jl")


function stdev(a::AbstractVector{<:Number})
    return sqrt(variance(a))
end

# assumes the number represents variance
function stdev(a::<:Number)
    return sqrt(a)
end
