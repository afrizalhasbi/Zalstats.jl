include("../common/rankorder.jl")

function spearman(x::AbstractArray{Number}, y::AbstractArray{Number})
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
