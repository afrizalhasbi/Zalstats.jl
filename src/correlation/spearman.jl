include("../common/common.jl")

function spearman(x::AbstractVector{<:Real}, y::AbstractVector{<:Real}, hypothesis::Union{String,Nothing}=nothing)
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

function spearman(formula::Formula, hypothesis::Union{String,Nothing}=nothing)
    x = formula.x
    y = formula.y
    return spearman(x, y, hypothesis)
end

function spearman(matrix::Matrix{<:Real})
    len = length(eachcol(matrix))
    corrs = []
    for (idx, col) in enumerate(eachcol(matrix))
        if idx == len
            break
        else
            push!(corrs, spearman(col |> Vector, matrix[:, idx+1] |> Vector))
        end
    end
    return to_symm(corrs)
end

# function spearman(m::Matrix{<:Real})
#     pairing = []
#     for i in 1 .. length(m) - 1
#         push!(pairing, (i, i + 1))
#     end
#     corrs = [spearman(p[1], p[2]) for p in pairing]
#     return to_symm(corrs)
# end
