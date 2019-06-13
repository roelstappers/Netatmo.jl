module Kernel 



struct SE{T} <: AbstractMatrix{T}
    sigmaf2::T
    r2::T    
    x::Array{T,1}
end 

import Base.size, Base.getindex, Base.*

Base.size(k::SE) = (size(k.x,1), size(k.x,1))
Base.getindex(K::SE, i1,i2 ) = make_se(K.sigmaf2,K.r2)(K.x[i1],K.x[i2])

Base.getindex(K::SE, i1::Integer,i2::Integer) = K.sigmaf2*exp.(-abs2.(K.x[i1]-K.x[i2])./K.r2)
Base.getindex(K::SE, ::Colon ,i2 )            = K.sigmaf2*exp.(-abs2.(K.x[:].-K.x[i2])./K.r2)
Base.getindex(K::SE, i1, ::Colon )            = K.sigmaf2*exp.(-abs2.(K.x[i1].-K.x[:])./K.r2)

make_se(sigmaf2,r2) = (x1,x2) -> sigmaf2*exp(-abs2(x1-x2)/r2)  # use @fastmath ?

function *(K::SE,q::AbstractVector) 
    out = Vector{Float64}(undef,size(q,1))
    for i in 1:size(q,1) 
        out[i] = 0.
        for j = 1:size(q,1)                 
           out[i] += K[i,j]*q[j]
        end 
    end 
end  

    #se = make_se(K.sigmaf2,K.r2) 
    #out = Array{Float64}(undef, size(q,1))
    #qt = q'
    
#    for i in 1:size(K.x,1)
#        out[i] = K[i,:]*q
#        # println(K.x[i])
#         out[i] = qt*se.(K.x[i], K.x)
#    end 
#    return out
#end 
end