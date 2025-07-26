function rankorder(v::AbstractVector{<:Real})
    sorted = sort(v)
    order = []
    for el in v
        idx = findfirst(x -> x == el, sorted)
        push!(order, idx)
    end
    return order
end

function rankorder(m::AbstractMatrix{<:Real})
    result = nothing
    for col in eachcol(m)
        if isnothing(result)
            result = rankorder(col)
        else
            result = hcat(result, rankorder(col))
        end
    end
    return result
end

function get_concdisc_pairs(v::AbstractMatrix{T}, target::AbstractMatrix{T}) where {T<:Real}
    @assert size(v)[2] == 2 "Source must be an m * 2 matrix!"
    @assert size(target) == (1, 2) "Target must be a single row of 2 columns!"

    tiesvec = (v .== target)   # bitvector buffer with values 0, 1 where 1 = tied

    # count rows where both columns are tied
    # int8 casting is used to minimize memory use
    # cast to int8 before summing, otherwise
    # it will create a temporary int64 vector
    tiesvec = sum(eachcol(Int8.(tiesvec)))
    ties = sum(tiesvec .== 2)


    x_larger = v[:, 1] .> target[1, 1]  # source x > target_x
    y_larger = v[:, 2] .> target[1, 2]  # source y > target_y

    # both true or both false (same direction)
    concvec = x_larger .== y_larger

    # as 1 = tied, a row is non-concordant if the
    # value changes when tiesvec is added elwise
    # we now get a new bitvector where 1 = concordant
    concvec = (concvec .+ tiesvec) .== concvec
    conc = sum(Int8.(concvec))

    # simply get disc by subtracting num rows
    # with ties and conc
    disc = size(v)[1] - conc - ties
    return [conc, disc, ties]
end

function get_concdisc_pairs(a::AbstractVector, b::AbstractVector)
    cdt = [0, 0, 0]
    matrix = hcat(a, b)
    for idx in eachindex(a) - 1
        tmp_cdt = get_concdisc_pairs(matrix[idx:end, :], matrix[idx, :])
        cdt .+= tmp_cdt
    end
    conc, disc, ties = cdt[1], cdt[2], cdt[3]
    conc, disc, ties
end
