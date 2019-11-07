using CSV, Dates, DataFrames, Plots, Statistics, StatsBase

if false
  baseurl = "http://klapp.met.no/metnopub/production/metno"
  s = [18700]
  p = ["PO"]; 

  pstr = join(p,"&p=") 
  sstr = join(s,"&s=")
  fd = "01.01.2010"
  td = "01.01.2015"
  param = "?re=17&p=$pstr&fd=$fd&td=$td&nmt=0&ddel=dot&del=semicolon&ct=text/plain&s=$sstr&nod=line"
  g = download(baseurl*param)
end 


filename="/home/roels/.julia/dev/Netatmo/blindern2010_2014.csv"
df = CSV.read(filename,types=[Int64, Int64, Int64,Int64,Int64,Float64])
# df[:DateTime] = DateTime.(df[:Year],df[:Month],df[:Day],df[Symbol("Time(UTC)")])

groupedbyStnr = groupby(df,:Stnr)
station=groupedbyStnr[1]


JJA(station,year) = filter(d-> (d[:Month] ∈ [6, 7,8]) .& (d[:Year] == year),station)
DJF(station,year) = filter(d-> ((d[:Month] == 12) .& (d[:Year] == year)) .| ((d[:Month] ∈ [1,2]) .& (d[:Year] == year+1)) ,station)

# plot(autocov(station[!,:PO],1:1:24*10),label="blindern")
plot(title="Autocovariance Blindern", xlabel="lag", ylabel= "covariance" )
plot!(autocov(JJA(station,2011)[!,:PO],1:1:24*10),label="JJA2011",color=:red, markershape=:circle, markersize=0.1)
plot!(autocov(JJA(station,2012)[!,:PO],1:1:24*10),label="JJA2012",color=:red, markershape=:star4, markersize=0.1)
plot!(autocov(JJA(station,2013)[!,:PO],1:1:24*10),label="JJA2013",color=:red, markershape=:star6, markersize=0.1)
plot!(autocov(DJF(station,2011)[!,:PO],1:1:24*10),label="DJF2011",color=:blue, markershape=:circle, markersize=0.1)
plot!(autocov(DJF(station,2012)[!,:PO],1:1:24*10),label="DJF2012",color=:blue, markershape=:star4, markersize=0.1)
plot!(autocov(DJF(station,2013)[!,:PO],1:1:24*10),label="DJF2013",color=:blue, markershape=:star6, markersize=0.1)

plot(title="Autocovariance Blindern", xlabel="lag", ylabel= "covariance" ))
plot!(autocor(JJA(station,2011)[!,:PO],1:1:24*10),label="JJA2011",color=:red, linestyle=:dot )
plot!(autocor(JJA(station,2012)[!,:PO],1:1:24*10),label="JJA2012",color=:red, linestyle=:solid )
plot!(autocor(JJA(station,2013)[!,:PO],1:1:24*10),label="JJA2013",color=:red, linestyle=:dash )
plot!(autocor(DJF(station,2011)[!,:PO],1:1:24*10),label="DJF2011",color=:blue, linestyle=:dot )
plot!(autocor(DJF(station,2012)[!,:PO],1:1:24*10),label="DJF2012",color=:blue, linestyle=:solid )
plot!(autocor(DJF(station,2013)[!,:PO],1:1:24*10),label="DJF2013",color=:blue,  linestyle=:dash )




plot!(autocov(station[!,:PO][24*30:24*30*2],1:1:24*10),label="M2")
plot!(autocov(station[!,:PO][24*30*2:24*30*3],1:1:24*10),label="M3")

plot()
makeplot(i) = plot!(autocov(station[!,:PO][24*91*i:24*91*(i+1)],1:1:24*10),label="M$i")

Mak(i) = plot!(autocov(station[station[!,:Month] .== i ,:PO],1:1:24*10),label="M$i",linewidth=2)

Mak.(2:2:11)
Mak(1)

for i in 1:10
makeplot(1) 
end


Cv(σ²,ν,ρ) = d  ->  σ² * 2.0^(1.0 - ν) / gamma(ν) * ( sqrt(2ν)*d/ρ)^ν * besselk(ν, sqrt(2ν)*d/ρ)

dd(l) = d -> 1. - 1/(1 + (d/l)^2)

plot!(Cv(1,5/2,24*3.5), 1:1:24*10,label="matern 5/2  4.5")
plot!(Cv(1,3/2,24*3.5), 1:1:24*10,label="matern 3/2  3.5")
plot!(Cv(1,1,24*3.5), 1:1:24*10,  label="matern 1    3.5")
plot!(Cv(1,0.5,24*4), 1:1:24*10,  label="matern 0.5  4.0")
plot!(Cv(1,0.6,24*4), 1:1:24*10,  label="matern 0.6  4.0")
plot!(dd(24*2), 1:1:24*10,  label="dd 2.0")

#plot!(autocov(station[:PO][365*24*1:365*24*1 + 90*24],0:1:24*10))
plot!(xscale=:log)

plot!(yscale=:log)
#plot!(autocov(station[:PO][365*24*2:365*24*2 + 90*24],0:1:24*10))
#plot!(autocov(station[:PO][365*24*3:365*24*3 + 90*24],0:1:24*10))


