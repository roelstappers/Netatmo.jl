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
station=groupedbyStnr[1
plot(autocov(station[:PO],0:1:24*10))
plot!(autocov(station[:PO][1:30*24],0:1:24*10))


