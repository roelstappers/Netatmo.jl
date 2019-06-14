include("kernels.jl")
import .Kernels
using IterativeSolvers, LinearAlgebra

n=10000
x = randn(n)
q = randn(n)

K = Kernels.SE(x,range=1.)

println("solving linear system")
# @time p1 = (K+ I)\q
@time p2, cglog = cg(K,q,log=true)

# println(cglog)



