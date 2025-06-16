include("../common/formula.jl")
include("../common/rank.jl")

function kendall(formula::Formula, hypothesis::Union{String,Nothing}=nothing)
    x = formula.x
    y = formula.y
    @assert length(x) == length(y), "Vector lengths must be equal"
    if !(hypothesis in ["frequentist", "bayesian", nothing])
        error("Hypothesis test must be 'frequentist', 'bayesian', or Nothing!")
    end
    @assert length(x) == length(y)
    N = length(x)
    conc, disc = get_concdisc_pairs(x, y)
    numer = 2 * disc
    denom = (N * (N - 1)) / 2
    corr = 1 - (numer / denom)
    return corr
end


function kendall(formula::Formula, hypothesis::Union{String,Nothing}=nothing)
    x = formula.x
    y = formula.y
    if !(hypothesis in ["frequentist", "bayesian", nothing])
        error("Hypothesis test must be 'frequentist', 'bayesian', or Nothing!")
    end
end
