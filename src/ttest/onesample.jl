include("../common/common.jl")


function onesample_ttest(
    V::AbstractVector{<:Real},
    target::Float64,
    ci::Float64=0.99,
    hypothesis::Union{String,Nothing}=nothing
)
    denom = mean(V) - target
    numer = (stdev(V) / stderror(V))
    t = denom / numer
    t
end
