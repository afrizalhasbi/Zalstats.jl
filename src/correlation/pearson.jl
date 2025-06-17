include("../common/common.jl")

function pearson(x::AbstractVector{<:Real}, y::AbstractVector{<:Real}, hypothesis::Union{String,Nothing}=nothing)
    if !(hypothesis in ["frequentist", "bayesian", nothing])
        error("Hypothesis test must be 'frequentist', 'bayesian', or Nothing!")
    end
    @assert length(x) == length(y) "Vector length must be equal!"
    numer = covariance(x, y)
    denom = stdev(x) * stdev(y)
    corr = numer / denom
    return corr
end

function pearson(formula::Formula, hypothesis::Union{String,Nothing}=nothing)
    x = formula.x
    y = formula.y
    return pearson(x, y, hypothesis)
end

function pearson(matrix::Matrix{<:Real})
    len = length(eachcol(matrix))
    corrs = []
    for (idx, col) in enumerate(eachcol(matrix))
        if idx == len
            break
        else
            push!(corrs, pearson(col |> Vector, matrix[:, idx+1] |> Vector))
        end
    end
    return to_symm(corrs)
end
