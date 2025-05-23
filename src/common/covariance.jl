include("mean.jl")

function covariance(a::AbstractVector, b::AbstractVector, population::Bool=false)
    if length(a) != length(b)
        error("Vector lengths must be equal!")
    end
    N = length(a)
    if population
        denom = N
    else
        denom = N - 1
    end
    numer = sum((a .- mean(a)) .* (b .- mean(b)))
    return numer / (N - 1)
end

function covariance(m::Matrix, population::Bool=false)
    rows, _ = size(m)
    nuT = (mean.(eachcol(m)))'
    mnuT = m .- nuT
    numer = (mnuT)' * (mnuT)
    if !(population)
        rows = rows - 1
    end
    return numer / rows
end
