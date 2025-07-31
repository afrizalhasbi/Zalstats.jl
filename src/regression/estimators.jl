using LinearAlgebra

include("../common/common.jl")
include("params.jl")

function ols(X::AbstractArray{<:Real}, Y::AbstractVector{<:Real})
    X_SD = [stdev(x) for x in eachcol(X)]
    Y_SD = stdev(Y)
    XT = X'
    B = inv(XT * X) * XT * Y
    B_std = B .* (X_SD ./ Y_SD)

    # these asserts are from a previous codebase
    # where i toyed around. but i forgot what these
    # are supposed to do
    @assert typeof(B) == AbstractVector
    @assert typeof(B_std) == AbstractVector
    LinRegParams(B, B_std)
end

function wls(X::AbstractArray{<:Real}, Y::AbstractVector{<:Real})
    # get the W Matrix
    # we do this by first fitting a regular OLS model,
    # then we fit another OLS model to the squared
    # residuals.
    ols_params = ols(X, Y)
    resids = ols_params(X) .- Y .^ 2
    resids_params = ols(X, resids)
    w_vec = 1 ./ (resids_params(X) .^ 2)
    W = Diagonal(w_vec)

    X_SD = [stdev(x) for x in eachcol(X)]
    Y_SD = stdev(Y)
    XT = X'
    B = inv(XT * W * X) * XT * Y
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
    B = inv(XT * X + lambda_i) * XT * Y
    B_std = B .* (X_SD ./ Y_SD)

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
