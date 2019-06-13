using DataFrames
using Dates
using Plots
import Netatmo

using CategoricalArrays


struct SE1D{T} <: AbstractMatrix{T}
    sigmaf2::T
    r2::T    
    x::Array{T}
end 

import Base.size
Base.size(k::SE1D) = (size(k.x,1), size(k.x,1))

make_se(sigmaf2,r2) = (x1,x2) -> sigmaf2*exp(abs2(x1-x2)/r2)  # use @fastmath ?

*(K::SE1D,q::AbstractVector) = [q'*se.(xi, K.x) for xi in K.x]


using GaussianProcesses

dtg = Dates.DateTime(2019,05,01,00)
period = Dates.Hour(24)

timerange = dtg:Minute(10):(dtg+period)
latrange  = 59.9:0.01:60  
lonrange  = 10.7:0.01:10.8
#latrange  = 59:0.01:60
#lonrange  = 7.:0.01:8



df = Netatmo.read(timerange, latrange=latrange, lonrange=lonrange);
println("Finished reading $(size(df,1)) rows")

s = groupby(df,:id)[2]

range  = log(60*60*4.)
sigma2 = log(sqrt(725049))
time = Float64.(s[:time_utc]) 
pressure = (s[:pressure] )

kernel = Mat12Iso(range,sigma2)
# kernel = SE(range,sigma2)
gp = GP(time,pressure,MeanZero(),kernel,-2.3)

pressurehat, sig = predict_y(gp,time) 
anom = pressure - pressurehat

gp_anom = GP(time,anom,MeanZero(),kernel,-2.3)

optimize!(gp_anom)
plot(gp)
gp

