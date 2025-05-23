export amean

function amean(x::Vector{<:Number})
    return sum(x) / length(x)
end


function amean(matrix::Matrix{<:Number})
    return @inbounds [sum(c) / length(c) for c in eachcol(matrix)]
end

# mean aliases for arithmetic mean
mean = amean
