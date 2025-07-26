include("../common/common.jl")
include("estimators.jl")
include("params.jl")

function __linreg_metrics(X::AbstractVector{<:Real}, Y::AbstractVector{<:Real}, params::AbstractRegParams, hypothesis::Union{String,Nothing}=nothing)
    if !(hypothesis in ["frequentist", "bayesian", nothing])
        error("Hypothesis test must be 'frequentist', 'bayesian', or Nothing!")
    end

    y_predicted = params(X, std=true)
    y_mean = mean(Y)
    y_centered = vec(Y .- y_mean)
    pred_centered = vec(y_predicted .- y_mean)
    residuals = vec(Y .- y_predicted)

    n, p = size(X)

    df_tot = n - 1    # Total df
    df_reg = p - 1    # Model df
    df_resids = n - p # Residual df

    tot_ss = sum(y_centered .^ 2)   # Σ(i=1 to n; (yi-ȳ)²)  Total Sum of Squares
    explained_ss = sum(pred_centered .^ 2)   # Σ(i=1 to n; (ŷi-ȳ)²)  Model/Regression/Explained Sum of Squares
    resids_ss = residuals .^ 2   # Σ(i=1 to n; (yi-ŷi)²) Residual Sum of Squares
    resids_ss = sum(resids_ss)
    @assert all([tot_ss >= 0, explained_ss >= 0, resids_ss >= 0])

    msr = explained_ss / df_reg
    mse = resids_ss / (n - p - 1) # Mean Squared error
    mae = mean(abs.(residuals))   # Mean Absolute Error
    rmse = sqrt(mse)        # Root Mean Squared Error
    se = sqrt.(mse .* [inv(X' * X)[i, i] for i in 1:p])  # Standard Error
    metrics = Result(se, mse, mae, rmse, msr, tot_ss, explained_ss, resids_ss, df_tot, df_reg, df_resids)
    return metrics
end

function linreg(
    X::AbstractArray{<:Real},
    Y::AbstractVector{<:Real},
    ci::Float64=0.99,
    estimator::Function=ols,
    hypothesis::Union{String,Nothing}=nothing
)

    @assert ci >= 1 && ci <= 0, throw(ArgumentError("Confidence interval must be in the range of 0-1!"))
    @assert length(X) == length(Y), throw(ArgumentError("Vectors must have equal length!"))

    intercept = ones(size(X, 1))
    X = hcat(intercept, X)

    params = estimator(X, Y)
    reg_metrics = __linreg_metrics(X, Y, params, hypothesis)

    return params, reg_metrics
end

"""
    linreg(
        formula::Formula, construct with ~(x, y),
        ci::Float64=0.99,
        estimator::Function=ols,
        hypothesis::Union{Bool, Nothing}=nothing
        )

Implementation of a vanilla linear regression.

Function args
  1. formula::Formula    ==> Formula.
  2. ci::Float64       ==> Confidence interval percentages, select between 0 and 1. Mandatory variable for best practices!
  3. estimator::Function   ==> Coefficient estimation method. Currently only supports OLS.
  4. hypothesis::Union{Bool, Nothing}=nothing ==> Run hypothesis testing on the estimated coefficients. Default to nothing.
"""
function linreg(
    formula::Formula{Real},
    ci::Float64=0.99,
    estimator::Function=ols,
    hypothesis::Union{String,Nothing}=nothing
)
    linreg(formula.x, formula.y, ci, estimator, hypothesis)
end

# alias
linreg_ols(
    formula::Formula{Real},
    ci::Float64=0.99,
    hypothesis::Union{String,Nothing}=nothing
) = linreg(formula.x, formula.y, ci, ols, hypothesis)

linreg_ols(
    X::AbstractArray{<:Real},
    Y::AbstractVector{<:Real},
    ci::Float64=0.99,
    hypothesis::Union{String,Nothing}=nothing
) = linreg(X, Y, ci, ols, hypothesis)

linreg_ridge(
    formula::Formula{Real},
    lambda::Float64,
    ci::Float64=0.99,
    hypothesis::Union{String,Nothing}=nothing
) = linreg(formula.x, formula.y, ci, ridge(lambda), hypothesis)

linreg_ridge(
    X::AbstractArray{<:Real},
    Y::AbstractVector{<:Real},
    lambda::Float64,
    ci::Float64=0.99,
    hypothesis::Union{String,Nothing}=nothing
) = linreg(X, Y, ci, ridge(lambda), hypothesis)
