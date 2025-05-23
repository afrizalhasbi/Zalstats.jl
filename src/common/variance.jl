include("mean.jl")

function variance(a::AbstractVector{<:Number})
    N = length(a)
    TSS = sum((a .- mean(a)) .^ 2)
    return TSS / (N - 1)
end

res = variance([1, 2, 3])
println(res)
