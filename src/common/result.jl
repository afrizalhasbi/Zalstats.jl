

struct Result
    se::AbstractVector
    mse::Float64
    mae::Float64
    rmse::Float64
    msr::Float64
    tot_ss::Float64
    explained_ss::Float64
    resids_ss::Float64
    df_tot::Int64
    df_reg::Int64
    df_resids::Int64
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
