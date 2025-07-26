include("stdev.jl")

function stderror(v::AbstractVector{<:Real})
    stdev(v) / length(v)
end
