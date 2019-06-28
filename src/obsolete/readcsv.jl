
import DataFrames
import TimeSeries
import CSV
using Glob
using Dates
using DelimitedFiles
using Plots
import PyPlot
import Dierckx
using IterativeSolvers
import Netatmo

dtg = Dates.DateTime(2019,05,10,12); YYYY = year(dtg); MM   = lpad(month(dtg),2,"0"); DD   = lpad(day(dtg),2,"0")
period = Dates.Minute(60)

## archiveroot = "/media/roels/_disk2/netatmo/$YYYY/$MM/$DD"
outdir = "/media/roels/_disk2/netatmopng/"

latrange = 58:0.01:64
lonrange = 4:0.01:13
timerange = datetime2unix(Dates.DateTime(dtg)):60*10:datetime2unix(Dates.DateTime(dtg + Day(1)))

df = Netatmo.read(dtg,period, latrange=latrange, lonrange=lonrange)

p = plot()
s = 100
p2 = plot(title="Pressure s=$s")
for s1 in DataFrames.groupby(df,:id)[2:3]
   println("dataframe size $(size(s1,1))")
   
   s1u   = unique(s1,:time_utc)   
   sp    = Dierckx.Spline1D(s1u[:time_utc],s1u[:pressure])    
   sp1ma = Dierckx.Spline1D(s1u[:time_utc],s1u[:pressure],s=s)
   
   anom = sp(timerange) - sp1ma(timerange)

   plot!(p, unix2datetime.(timerange),anom)
   plot!(p2,unix2datetime.(s1u[:time_utc]), s1u[:pressure],legend=false) 
   plot!(p2,unix2datetime.(timerange),sp1ma(timerange),legend=false)

   
end
savefig(p2,"$outdir/pressure_s=$(s)_$dtg.png")


p2 = plot(title="Pressure", xlabel="Time (UTC)", ylabel= "Pressure (hPa)")


for t in timerange
   println("Processing: $(unix2datetime(t))")
   y = Float64[]
   z = Float64[]
   x = Float64[]
   
   for s1 in DataFrames.groupby(df,:id)
     #  println("dataframe size $(size(s1,1))")
      if size(s1,1)  < 70
         continue
      end 
      s1u = unique(s1,:time_utc)  
      
      if !issorted(s1u)
         println("time not sorted in $(s1[:id][1])")
         continue
      end

      sp    = Dierckx.Spline1D(s1u[:time_utc],s1u[:pressure])    
      sp1ma = Dierckx.Spline1D(s1u[:time_utc],s1u[:pressure],s=s)
      
       
      append!(x, s1[:lon][1])
      append!(y, s1[:lat][1])    
      append!(z, sp(t) - sp1ma(t))
      oslo[:id,]         
     
   end
   tf = (z.>2.) .| (z.<-2.)
   deleteat!(x,tf)
   deleteat!(y,tf)
   deleteat!(z,tf)
   

   
   # sp2d = Dierckx.Spline2D(x,y,z,s=100.)
   

   lonlat = zip(x,y)
   RBF(x,y,l) = exp(norm(x1-y)^2/2*l^2 ) # could avoid square root here in norm

   K    = [RBF(x1,x2,10) for x1 in lonlat, x2 in lonlat]  
   q    = minres(K,z)

   val(lon,lat) = [RBF([lon lat],x,10) for x in lonlat] * q   

   pcon = contour(lonrange,latrange,(x,y) -> val(x,y),fill=true,seriescolor= cgrad(ColorSchemes.RdBu_10.colors), clim=(-1.,1.) )


   PyPlot.figure() 
   PyPlot.scatter(x,y,marker="o",s=0.05,color="green")
   pcon = contour(lonrange,latrange,(x,y) -> sp2d(x,y),fill=true,seriescolor= cgrad(ColorSchemes.RdBu_10.colors), clim=(-1.,1.) )
   PyPlot.tricontourf(x,y,z,collect(-1.:0.1:1.),  cmap="RdBu_r",vmin=-1.,vmax=1,alpha = 0.6)
   PyPlot.title(unix2datetime(t))
   
   # PyPlot.set_cmap("RdBu")
   # PyPlot.set_clim(-0.5,0.5)
   PyPlot.colorbar()
   
   # scatter!(x,y,markersize=0.1,legend=false)
   PyPlot.savefig("$outdir/pyplot_s=$(s)_$(unix2datetime(t)).png",dpi=300)   
    # savefig("pyplot$(unix2datetime(t)).png")
end 
