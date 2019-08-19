module Kernels 

import Base: size, getindex


struct Kernel{T}  <: AbstractMatrix{T}
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


"""
   se(alpha=alpha) 

  squared exponential covariance function 
"""
se(;sigma,aplha) = (x,y) -> sigma^2*exp(-norm(x-y)^2/alpha) 


"""
   Cv(;nu,sigma) 
"""

# Cv(;sigma,nu) = (x,y) -> sigma^2*2^(1-nu)/Gamma(v)*(sqrt(2*nu*norm(x-y)/rho  ) ) 

C12

function Cv(;sigma,nu)
    if nu==1/2
        return C1/2(sigma;nu)
    elseif nu=3/2
        eturn 
    return 




end