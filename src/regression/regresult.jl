struct RegressionCoefficients
    beta::AbstractVector{<:Real}
    beta_std::AbstractVector{<:Real}
    function as_linreg()
        return LinearRegression(beta, beta_std)
    end
    function as_logreg()
        return LogisticRegression(beta, beta_std)
    end
end

struct LinearRegression
    beta::Vector{<:Real}
    beta_std::Vector{<:Real}
end
function (rc::LinearRegression)(vec::AbstractVector{<:Real}; std::Bool=false)
    @assert length(vec) == length(rc.beta) == length(rc.beta_std) "length mismatch"
    coeffs = std ? rc.beta_std : rc.beta
    return vec .* coeffs
end

struct LogisticRegression
    beta::Vector{<:Real}
    beta_std::Vector{<:Real}
end
