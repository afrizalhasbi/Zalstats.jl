
function median(v::AbstractVector{Number})
    v = sort(v)
    N = length(v)
    middle = N / 2
    if N % 2 == 0
        return (v[Int(middle)] + v[Int(middle)+1]) / 2
    else
        return v[Int(ceil(middle))]
    end
end


function median(m::Matrix{Number})

end
