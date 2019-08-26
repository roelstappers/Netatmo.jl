module Kernels 

using LinearAlgebra, SpecialFunctions
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

se(;sigma,l) = (x,y) -> sigma^2*exp(-1/2*norm(x-y)^2/l) 


"""
   Cv(;nu,sigma) 
"""

Cv(σ²,ν,ρ) = (x,y)  ->  σ² * 2.0^(1.0 - ν) / gamma(ν) * ( sqrt(2ν)*norm(x-y)/ρ)^ν * besselk(ν, sqrt(2ν)*norm(x-y)/ρ)
Cinf(σ²,ρ) = (x,y)  ->  σ² * exp(-1/2*(norm(x-y)/ρ)^2)




