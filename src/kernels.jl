module Kernels 

import Base: size, getindex


struct Kernel{T}  <: AbstractArray{T,2}
    x::Array{T,1}
    y::Array{T,1}    
    cov::Function    
end 


Base.size(K::Kernel) = (size(K.x,1),size(K.y,1))
Base.getindex(K::Kernel, i, j) where T = K.cov(K.x[i], K.y[j]) 


"""
   se(alpha=alpha) 

  squared exponential covariance function 
"""
se(;alpha) = (x,y) -> exp(-alpha*abs2(x-y)) 





end