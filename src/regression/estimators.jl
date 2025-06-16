include("../common/common.jl")
include("regresult.jl")

function ols(X::AbstractArray{<:Real}, Y::AbstractVector{<:Real})
    X_SD = [stdev(x) for x in eachcol(X)]
    Y_SD = stdev(Y)
    XT = X'
    B = inv(XT * X) * XT * Y
    B_std = B .* (X_SD ./ Y_SD)

    @assert typeof(B) == AbstractVector
    @assert typeof(B_std) == AbstractVector
    LinearRegression(B, B_std)
end

function logistic(X::AbstractArray{<:Real}, Y::AbstractVector{<:Real})
    X_SD = [stdev(x) for x in eachcol(X)]
    Y_SD = stdev(Y)
    XT = X'
    B = inv(XT * X) * XT * Y
    B_std = B .* (X_SD ./ Y_SD)

    @assert typeof(B) == AbstractVector
    @assert typeof(B_std) == AbstractVector
    LogisticRegression(B, B_std)
end
