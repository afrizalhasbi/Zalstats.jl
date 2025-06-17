include("../common/common.jl")

function kendall(x::AbstractVector{<:Real}, y::AbstractVector{<:Real}, hypothesis::Union{String,Nothing}=nothing)
    @assert length(x) == length(y) "Vector lengths must be equal"
    @assert (hypothesis in ["frequentist", "bayesian", nothing]) "Hypothesis test must be 'frequentist', 'bayesian', or Nothing!"

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
    kendall(x, y, hypothesis)
end

function kendall(matrix::Matrix{<:Real})
    len = length(eachcol(matrix))
    corrs = []
    for (idx, col) in enumerate(eachcol(matrix))
        if idx == len
            break
        else
            push!(corrs, kendall(col |> Vector, matrix[:, idx+1] |> Vector))
        end
    end
    return to_symm(corrs)
end
