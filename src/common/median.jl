
function median(v::AbstractVector{<:Real})
    v = sort(v)
    n = length(v)
    middle = n / 2
    if n % 2 == 0
        return (v[Int(middle)] + v[Int(middle)+1]) / 2
    else
        return v[Int(ceil(middle))]
    end
end


function median(m::Matrix{Number})

end
