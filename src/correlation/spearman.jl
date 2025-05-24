include("../common/rankorder.jl")

function spearman(x::Array{Number}, y::Array{Number}, hypothesis::Union{String,Nothing}=nothing)
    @assert length(x) == length(y)
    if !(hypothesis in ["frequentist", "bayesian", nothing])
        error("Hypothesis test must be 'frequentist', 'bayesian', or Nothing!")
    end
    x, y = rankorder(x), rankorder(y)
    N = length(x)
    d = sum((x .- y) .^ 2)
    numer = 6 * d
    denom = N * (N^2 - 1)
    corr = 1 - (numer / denom)
    return corr
end


function spearman(m::Matrix{Number})
    # l
end
