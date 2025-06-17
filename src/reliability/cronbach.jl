include("../common/common.jl")

function cronbach(mat::AbstractMatrix)
    k = length(eachcol(mat))
    itemvariances = 0
    totvariances = 0
    for col in eachcol(mat)
        itemvariances += variance(col)
    end
    for row in eachrow(mat)
        totvariances += variance(row)
    end
    left = k / (k - 1)
    right = 1 - (itemvariances / totvariances)
    return left / right
end
