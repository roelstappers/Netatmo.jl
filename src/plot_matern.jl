
using SpecialFunctions
using Plots

Cv(σ²,ν,ρ) = d  ->  σ² * 2.0^(1.0 - ν) / gamma(ν) * ( sqrt(2ν)*d/ρ)^ν * besselk(ν, sqrt(2ν)*d/ρ)

Cinf(σ²,ρ) = d  ->  σ² * exp(-1/2*(d/ρ)^2)

plot(Cv(1,0.5,1),0:0.01:3,label="nu=0.5")
plot!(Cv(1,1,1),0:0.01:3,label="nu=1")
plot!(Cv(1,3/2,1),0:0.01:3,label="nu=3/2")
plot!(Cv(1,5/2,1),0:0.01:3,label="nu=5/2")
plot!(Cinf(1,1),0:0.01:3,label="nu=inf")