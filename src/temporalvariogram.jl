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
plot(autocov(station[:PO],0:1:24*10),label="blindern")

Cv(σ²,ν,ρ) = d  ->  σ² * 2.0^(1.0 - ν) / gamma(ν) * ( sqrt(2ν)*d/ρ)^ν * besselk(ν, sqrt(2ν)*d/ρ)

plot!(Cv(132,5/2,24*3.5), 0:1:24*10,label="matern 5/2  4.5")
plot!(Cv(132,3/2,24*3.5), 0:1:24*10,label="matern 3/2  3.5")
plot!(Cv(132,1,24*3.5), 0:1:24*10,  label="matern 1    3.5")
plot!(Cv(132,0.5,24*4), 0:1:24*10,  label="matern 0.5  4.0")
plot!(Cv(132,0.6,24*4), 0:1:24*10,  label="matern 0.6  4.0")

#plot!(autocov(station[:PO][365*24*1:365*24*1 + 90*24],0:1:24*10))
#plot

#plot!(autocov(station[:PO][365*24*2:365*24*2 + 90*24],0:1:24*10))
#plot!(autocov(station[:PO][365*24*3:365*24*3 + 90*24],0:1:24*10))


