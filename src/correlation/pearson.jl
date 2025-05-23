include("../common/covariance.jl")
include("../common/stdev.jl")

function pearson(x::Array{Number}, y::Array{Number}, hypothesis::Union{String,Nothing}=nothing)
    @assert length(x) == length(y)
    if !(hypothesis in ["frequentist", "bayesian", nothing])
        error("Hypothesis test must be 'frequentist', 'bayesian', or Nothing!")
    end
    N = length(x)
    numer = covariance(x, y)
    denom = stdev(x) * stdev(y)
    corr = numer / denom
    return corr
end


function pearson(m::Matrix{Number})
    # l
end
