function to_symm(v::AbstractVector)
    v = [1.0; v]         # prepend 1.0
    n = length(v)
    mats = [circshift(v, i) for i in 0:n-1]
    return hcat(mats...)
end
