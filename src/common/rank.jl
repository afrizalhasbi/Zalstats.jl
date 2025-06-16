function rankorder(v::AbstractVector{<:Real})
    ord = sort(v)
    return v, ord
end

function rankorder(m::AbstractMatrix{<:Real})
    result = []
    for col in eachcol(m)
        hcat(result, rankorder(col))
    end
    return result
end

function get_concdisc_pairs(a::AbstractVector, b::AbstractVector)
    @assert length(a) == length(b)
    N = length(a)
    a2, a, b2, b = a[1:N-1], a[2:end], b[1:N-1], b[2:end]
    A, B = sign.(a .- a2), sign.(b .- b2)
    disc = sum(A .!= B)
    conc = N - 1 - disc

    return conc, disc
end
