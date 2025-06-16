struct Formula{T<:Real}
    x::AbstractVector{T}
    y::AbstractArray{T}
end


function ~(X::AbstractVector{<:Real}, Y::AbstractArray{<:Number})
    Formula(X, Y)
end
