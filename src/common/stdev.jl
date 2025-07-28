include("variance.jl")

function stdev(a::AbstractVector{<:Real})
    return sqrt(variance(a))
end

# assumes the number represents variance
function stdev(a::Real)
    return sqrt(a)
end

function stdev_pooled(v1::AbstractVector{<:Real}, v2::AbstractVector{<:Real})
	var1 = variance(v1)
	var2 = variance(v2)
	n1 = length(v1)
	n2 = length(v2)
	denom = ((n1 - 1) * var1) + ((n2 - 1) * var2)
	numer = n1 + n2 - 2
	sqrt(denom / numer)
end
