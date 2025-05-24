include("../common/stdev.jl")
include("../common/mean.jl")
include("../common/result.jl")

function _compute_coeff_rg(X::AbstractVector{<:Number}, Y::AbstractVector{<:Number}, method::String="ols")
    intercept = ones(size(X, 1))
    if X[:, 1] != intercept
        X = hcat(intercept, X)
    end
    X_SD = [stdev(x) for x in eachcol(X)]
    Y_SD = stdev(Y)
    if method == "ols"
        XT = X'
        B = inv(XT * X) * XT * Y
        β = B .* (X_SD ./ Y_SD)
    end

    function regression(V::AbstractVector{<:Number}, std::Bool=false)
        if std
            return V .* β
        else
            return V .* B
    end

    return regression
end

function _regfn(X::AbstractVector{<:Number}, Y::AbstractVector{<:Number}, regfn::Function, hypothesis::String)
    if !(hypothesis in ["frequentist", "bayesian", nothing])
        error("Hypothesis test must be 'frequentist', 'bayesian', or Nothing!")
    end
    intercept = ones(size(X, 1))
    if X[:, 1] != intercept
        X = hcat(intercept, X)
    end
    Ŷ = regfn(X, std=true)
    Ȳ = mean(Y)
    ΔYȲ = vec(Y .- Ȳ)
    ΔŶȲ = vec(Ŷ .- Ȳ)
    ΔYŶ = vec(Y .- Ŷ)

    n, p = size(X)

    df_tot = n - 1    # Total df
    df_reg = p - 1    # Model df
    df_resids = n - p # Residual df

    TSS = sum(ΔYȲ .^ 2)   # Σ(i=1 to n; (yi-ȳ)²)  Total Sum of Squares
    MSS = sum(ΔŶȲ .^ 2)   # Σ(i=1 to n; (ŷi-ȳ)²)  Model/Regression/Explained Sum of Squares
    RSS_vector = ΔYŶ .^ 2   # Σ(i=1 to n; (yi-ŷi)²) Residual Sum of Squares
    RSS = sum(RSS_vector)
    @assert all([TSS >= 0, MSS >= 0, RSS >= 0])

    MSR = MSS / df_reg
    MSE = RSS / (n - p - 1) # Mean Squared error
    MAE = mean(abs.(ΔYŶ))   # Mean Absolute Error
    RMSE = sqrt(MSE)        # Root Mean Squared Error
    SE = sqrt.(MSE .* [inv(X' * X)[i, i] for i in 1:p])  # Standard Error
    output = Result(SE, MSE, MAE, RMSE, MSR, TSS, MSS, RSS, df_tot, df_reg, df_resids)
    return output
end


"""
    llinreg(
        X::AbstractVector{<:Number},
        Y::AbstractVector{<:Number};
        CI::Float64=0.99,
        method::String="ols",
        hypothesis::Bool=true
        )

Implementation of a vanilla linear regression.

Function args
  1. vars::regvars    ==> A regression variable struct. Instantiate with regvars(y,hcat(x1, x2, ..xn)).
  2. CI::Number       ==> Confidence interval percentages, select between 0 and 1. Mandatory variable for best practices!
  3. method::String   ==> Coefficient estimation method. Currently only supports OLS.
  4. hypothesis::Bool ==> Run hypothesis testing on the estimated coefficients. Default to true.
"""
function linreg(X::AbstractVector{<:Number}, Y::AbstractVector{<:Number};
    CI::Float64=0.99, method::String="ols",
    hypothesis::Bool=true)
    @assert CI >= 1 && CI <= 0, error("CI must be in the range of 0-1!")
    @assert length(X) == length(Y), "Vectors must have equal length"

    reg_fn = _compute_coeff_rg(X, Y, method)

    regout = _regfn(X, Y, reg_fn, hypothesis)

    return reg_fn, regout
end
