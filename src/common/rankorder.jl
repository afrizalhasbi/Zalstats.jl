function rankorder(v::AbstractVector{<:Number})
    ord = sort(v)
    return v, ord
end

function rankorder(m::AbstractMatrix{<:Number})
    # ord = sort(v)
    # return v, ord
end
