using LinearAlgebra

include("../common/common.jl")

function get_pc_matrix(eigendecomp)

end

function principal_components(m::Matrix, top_k=Int)
    colmeans = amean(m)
    # center the columns
    for (colmean, col) in zip(colmeans, eachcol(m))
        col = col - colmean
    end
    cov = covariance(m)
    E = eigen(cov)
    zipped = [(val, E.vectors[:, idx]) for (idx, val) in enumerate(E.values)]
    sort!(zipped, by=x -> x[1], rev=true)

    cumulative_variance = Vector{Float64}(0, length(zipped))
    explained_variance = Vector{Float64}(0, length(zipped))
    tmp = 0
    for idx in range(1, length(zipped))
        cum = zipped[idx][1] + tmp
        tmp = cum
        push!(explained_variance, zipped[idx][1])
        push!(cumulative_variance, cum)
    end

    pc_matrix = m * zipped[1:top_k]

    return explained_variance, cumulative_variance, pc_matrix
end
