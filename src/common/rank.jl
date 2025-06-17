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

function get_concdisc_pairs(a::AbstractVector, b::AbstractVector)
    @assert length(a) == length(b) "Vector lengths must be equal!"
    N = length(a)
    a2, a, b2, b = a[1:N-1], a[2:end], b[1:N-1], b[2:end]
    A, B = sign.(a .- a2), sign.(b .- b2)
    disc = sum(A .!= B)
    conc = N - 1 - disc

    return conc, disc
end
