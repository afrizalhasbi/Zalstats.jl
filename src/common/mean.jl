export amean

function amean(x::Vector{<:Real})
    return sum(x) / length(x)
end


function amean(matrix::Matrix{<:Real})
    return @inbounds [sum(c) / length(c) for c in eachcol(matrix)]
end

# mean aliases for arithmetic mean
mean = amean
