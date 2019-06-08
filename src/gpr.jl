using DataFrames
import TimeSeries
import CSV
using Glob
using Dates
using Plots
import Netatmo
import PyPlot
using LinearAlgebra
using IterativeSolvers

dtg = Dates.DateTime(2018,05,10,16)
period = Dates.Hour(2)

timerange = datetime2unix(dtg):60*10:datetime2unix(dtg+period)
latrange  = 59.9:0.01:60  
lonrange  = 10.7:0.01:10.8
latrange  = 59:0.01:60
lonrange  = 7.:0.01:8

df = Netatmo.read(timerange, latrange=latrange, lonrange=lonrange);

println("Finished reading $(size(df,1)) rows")


function RBF(row1,row2) 
    lt = 1.0/(2.0*(1.0*60.0*60.0)^2) # time length scale 
    lx = 1.0/(2.0*(0.01)^2)       # latlon length scale 
    dtsq   = -lt*(row1[:time_utc] - row2[:time_utc])^2
    dlatsq = -lx*(row1[:lat] - row2[:lat])^2
    dlonsq = -lx*(row1[:lon] - row2[:lon])^2    
    return exp(dlatsq + dlonsq + dtsq)
end



sigmao = 1  

K   = [RBF(r1,r2) for r1 in eachrow(df), r2 in eachrow(df)] 

groupbyid = DataFrames.groupby(df,:id)
by(df,:id) do s1
    s1[:pressure] - Statistics.mean(s1[:pressure])
    DataFrames.DataFrame(anom=s1[:pressure])
end

lt = 1.0/(2.0*(6.0*60.0*60.0)^2) # time length scale 
lx = 1.0/(2.0*(0.1)^2)       # latlon length scale     
for s1 in groupbyid
   for s2 in groupbyid 
      dlatsq = -lx*(s1[:lat][1] - s2[:lat][1])^2
      dlonsq = -lx*(s1[:lon][1] - s2[:lon][1])^2 
      c1 = exp(dlatsq+dlonsq)   
      println(s1[:time_utc]) 
      for t1 in s1[:time_utc]    
         for t2 in s2[:time_utc]
            
            dtsq = -lt*(t1 - t2)^2          
            K[s1[:id][1],s2[:id],t1,t2] = c1*exp(dtsq)
         end                  
      end 
   end 
end

KpI = K  
KpI[diagind(KpI)] .= 1 + sigmao^2

q,minreslog= minres(KpI,df[:pressure],log=true)


# K_s  = [RBF(r1,r2) for t1 in tf, t2 in timerange]
# K_ss = [RBFl(t1,t2) for t1 in timerange, t2 in timerange]
#   K[diagind(K)] .= 1 + sigmao^2
#q,log= minres(K,s1u[:pressure],log=true)
#   smooth = K_s'* q
   
#   plot!(p,unix2datetime.(tf), s1u[:pressure],m=:o,markersize=1)
#   plot!(p,unix2datetime.(timerange),smooth)
#end
#p