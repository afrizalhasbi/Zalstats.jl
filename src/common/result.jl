struct Regcoeff
    B::Vector{Float64}
    β::Vector{Float64}
    function Regcoeff(B, β)
        new(B, β)
    end
end

struct Result
    SE::Vector{Real}
    MSE::Float64
    MAE::Float64
    RMSE::Float64
    MSR::Float64
    TSS::Float64
    MSS::Float64
    RSS::Float64

    df_tot::Int64
    df_reg::Int64
    df_resids::Int64
    function Result(SE, MSE, MAE, RMSE, MSR, TSS, MSS, RSS, df_tot, df_reg, df_resids)
        new(SE, MSE, MAE, RMSE, MSR, TSS, MSS, RSS, df_tot, df_reg, df_resids)
    end
end

struct HypothesisTest
    F::Float64
    P::Float64
    t::Vector{Float64}
    XP::Vector{Float64}
    R²::Float64
    R::Float64
    conf::Vector{String}
    function _hypothesis_rg_out(F, P, t, XP, R², R, conf)
        new(F, P, t, XP, R², R, conf)
    end
end
