module Kernels 

import Base: size, getindex
export SE, Interpolator,Kernel

abstract type Kernel{T}  <: AbstractArray{T,2} end

"""Squared exponential Kernel
"""
struct SE{T} <: Kernel{T}   
    x::Array{T,1}
    y::Array{T,1}    
    alpha::T  
    # sigmaf2::T     
end 

make_SE(;range::T) where T = (x::Array{T,1},y::Array{T,1}) -> SE(x,y,-1.0/(2*range)) 

#SE(x::Array{Float64}, y::Array{Float64}; range) = SE(x,y, )
# SE(x::Array{Float64}; range) = SE(x,x; range=range)

Base.size(k::SE) = (size(k.x,1),size(k.y,1))
Base.getindex(K::SE, i, j) = exp.(K.alpha*abs2.(K.x[i].-K.y[j])) 

#struct Interpolator{T}
#    Kinvval::Array{T}
#    Kerneltype::DataType  
#end

#function Interpolator(val::Array{T},K::Kernel{T}) where T
#    Interpolator{T}(K\val, typeof(K))
#end 


#function (itp::Interpolator{T})(x::T) where T
#  Kstar = Kerneltype(x, itp.K.x, 2.) 
#  return Kstar*itp.val    
#end 

end