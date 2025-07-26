abstract type AbstractRegParams end

struct LinRegParams <: AbstractRegParams
    beta::Vector{<:Real}
    beta_std::Vector{<:Real}
end
function (rc::LinRegParams)(vec::AbstractVector{<:Real}; std::Bool=false)
    @assert length(vec) == length(rc.beta) == length(rc.beta_std) "Vector length must be equal!"
    coeffs = std ? rc.beta_std : rc.beta
    return vec .* coeffs
end

struct LogRegParams <: AbstractRegParams
    beta::Vector{<:Real}
    beta_std::Vector{<:Real}
end
