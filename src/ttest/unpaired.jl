include("../common/common.jl")

function ttest_student(
    v1::AbstractVector{<:Real},
    v2::AbstractVector{<:Real},
    ci::Float64=0.99,
    hypothesis::Union{String,Nothing}=nothing
)
    t = (mean(v1) - mean(v2)) / stdev_pooled(v1, v2)
    t
end

function ttest_welch(
    v1::AbstractVector{<:Real},
    v2::AbstractVector{<:Real},
    ci::Float64=0.99,
    hypothesis::Union{String,Nothing}=nothing
)
    denom = mean(v1) - mean(v2)
    numer = sqrt(stdev(v1) + stdev(v2))
    t = denom / numer
    t
end
