include("stdev.jl")

function stderror(v::AbstractVector{<:Real})
    stdev(v) / length(v)
end

function stderror_pooled(v1::AbstractVector{<:Real}, v2::AbstractVector{<:Real})
	n1 = length(v1)
	n2 = length(v2)
	stdev_pooled(v1,v2) * sqrt(1/n1 + 1/n2)
end
