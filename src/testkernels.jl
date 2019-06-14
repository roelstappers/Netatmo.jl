include("kernels.jl")
import .Kernels
using IterativeSolvers, LinearAlgebra

n=1000
x = randn(n)
q = randn(n)

#K = Kernels.SE(x,range=1.)

#println("solving linear system")
# @time p1 = (K+ I)\q
#@time p2, cglog = cg(K+I,q,log=true)

x = 5*randn(100)
y = sin.(x) 
sigmao=0.3
y = y+sigmao^2*randn(100)
xstar = collect(-10:0.1:10)
K = Kernels.make_SE(range=1.)
yhat = K(xstar,x) * ((K(x,x) + sigmao^2*I)\y)

using Plots
scatter(x,y)
plot!(xstar,yhat)


# println(cglog)




