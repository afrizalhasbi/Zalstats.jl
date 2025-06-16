include("linreg.jl")
include("estimators.jl")

function isbinaryclass(arr::AbstractVector{<:Int})
    s = Set()
    for el in arr
        push!(s, el)
        if length(s) > 2
            return false
        end
    end
    return true
end

function logreg(
    X::AbstractArray{<:Real},
    Y::AbstractVector{<:Real},
    ci::Float64=0.99,
    hypothesis::Bool=true
)
    @assert isbinaryclass(Y), throw(ArgumentError("Dependent variable has more than 1 class"))
    linreg(X, Y, ci, logistic, hypothesis)
end

function logreg(
    formula::Formula,
    ci::Float64=0.99,
    hypothesis::Bool=true
)
    x = formula.x |> Array
    y = formula.y |> Vector
    logreg(x, y, ci, logistic, hypothesis)
end
