
function mode(x::AbstractVector{<:Real})
    frequencies = Dict()
    for i in x
        if frequencies.haskey(i)
            frequencies[i] += 1
        else
            frequencies[i] = 1
        end
        return frequencies
    end
end
