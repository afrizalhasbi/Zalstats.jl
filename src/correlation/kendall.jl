include("../common/common.jl")

function kendalla(x::AbstractVector{<:Real}, y::AbstractVector{<:Real}, hypothesis::Union{String,Nothing}=nothing)
    @assert length(x) == length(y) "Vector lengths must be equal"
    @assert (hypothesis in ["frequentist", "bayesian", nothing]) "Hypothesis test must be 'frequentist', 'bayesian', or Nothing!"

    conc, disc, ties = get_concdisc_pairs(x, y)
    numer = conc - disc
    denom = length(x)

    corr = numer / denom
    return corr
end


function kendalla(formula::Formula, hypothesis::Union{String,Nothing}=nothing)
    x = formula.x
    y = formula.y
    kendalla(x, y, hypothesis)
end

function kendalla(matrix::Matrix{<:Real})
    len = length(eachcol(matrix))
    corrs = []
    for (idx, col) in enumerate(eachcol(matrix))
        if idx == len
            break
        else
            push!(corrs, kendalla(col |> Vector, matrix[:, idx+1] |> Vector))
        end
    end
    return to_symm(corrs)
end
