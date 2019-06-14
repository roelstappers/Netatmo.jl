module Kernels 

import Base.size, Base.getindex

"""Squared exponential Kernel
"""
struct SE{T} <: AbstractMatrix{T}    
    x::Array{T,1}
    y::Array{T,1}
    alpha::T       
end 

SE(x::Array{Float64}, y::Array{Float64}; range) = SE(x,y, -1.0/(2*range))
SE(x::Array{Float64}; range) = SE(x,x; range=range)

Base.size(k::SE) = (size(k.x,1),size(k.y,1))
Base.getindex(K::SE, i1::Integer,i2::Integer) = @fastmath exp(K.alpha*abs2(K.x[i1]-K.x[i2])) + (i1==i2 ? 1.0 : 0.0 )

end