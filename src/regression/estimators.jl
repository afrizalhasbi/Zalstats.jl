using LinearAlgebra

include("../common/common.jl")
include("params.jl")

function ols(X::AbstractArray{<:Real}, Y::AbstractVector{<:Real})
    X_SD = [stdev(x) for x in eachcol(X)]
    Y_SD = stdev(Y)
    XT = X'
    B = inv(XT * X) * XT * Y
    B_std = B .* (X_SD ./ Y_SD)

    @assert typeof(B) == AbstractVector
    @assert typeof(B_std) == AbstractVector
    LinRegParams(B, B_std)
end

function ridge(X::AbstractArray{<:Real}, Y::AbstractVector{<:Real}, lambda::Float64)
    X_SD = [stdev(x) for x in eachcol(X)]
    Y_SD = stdev(Y)
    XT = X'

    lambda_i = Matrix(I, size(X)) .* lambda
    B = inv((XT * X) + lambda_i) * XT * Y    B_std = B .* (X_SD ./ Y_SD)

    @assert typeof(B) == AbstractVector
    @assert typeof(B_std) == AbstractVector
    LinRegParams(B, B_std)
end

function ridge(lambda::Float64)
    function _ridge(X::AbstractArray{<:Real}, Y::AbstractVector{<:Real})
        ridge(X, Y, lambda)
    end
    _ridge
end

function logistic(X::AbstractArray{<:Real}, Y::AbstractVector{<:Real})
    X_SD = [stdev(x) for x in eachcol(X)]
    Y_SD = stdev(Y)
    XT = X'
    B = inv(XT * X) * XT * Y
    B_std = B .* (X_SD ./ Y_SD)

    @assert typeof(B) == AbstractVector
    @assert typeof(B_std) == AbstractVector
    LogRegParams(B, B_std)
end
