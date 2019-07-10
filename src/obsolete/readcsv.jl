
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

dtg = Dates.DateTime(2019,06,26,18); 
dtgend = Dates.DateTime(2019,06,26,20); 

## archiveroot = "/media/roels/_disk2/netatmo/$YYYY/$MM/$DD"
outdir = "/home/roels/fig4/"

latrange = 58:0.01:64
lonrange = 4:0.01:13

latrange = 59.5:0.01:60.5
lonrange = 10.3:0.01:11.3
timerange = Dates.DateTime(dtg):Dates.Minute(1):Dates.DateTime(dtgend)

df = Netatmo.read(timerange, latrange=latrange, lonrange=lonrange)


timerange = datetime2unix.(timerange)

p = plot()
s = 5
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

# anim = Animation()
for t in timerange
   println("Processing: $(unix2datetime(t))")
   y = Float64[]
   z = Float64[]
   x = Float64[]
   z2 = Float64[]
   
   for s1 in DataFrames.groupby(df,:id)
      # println("dataframe size $(size(s1,1))")
      if size(s1,1)  < 5
         continue
      end 
      s1u = unique(s1,:time_utc)  
      
      if !issorted(s1u)
         println("time not sorted in $(s1[:id][1])")
         continue
      end

      
      sp    = Dierckx.Spline1D(s1u[:time_utc],s1u[:pressure])    
      sp1ma = Dierckx.Spline1D(s1u[:time_utc],s1u[:pressure],s=s)
      
      
      #val=Float64[]
      #for v in s1u[:sum_rain_1]
      #   # println(v)
      #   if ismissing(v)
      #      append!(val,0.)
      #   else 
      #      append!(val,v)
      #   end 
      #end 
      
      #rr1    = Dierckx.Spline1D(s1u[:time_utc],val)    
      
     
      # println("append")
      append!(x, s1[:lon][1])
      append!(y, s1[:lat][1])    
      append!(z, sp(t) - sp1ma(t))
      #append!(z2, rr1(t))
#       oslo[:id,]         
     
   end
  # tf = (z.>2.) .| (z.<-2.)
  # deleteat!(x,tf)
  # deleteat!(y,tf)
  # deleteat!(z,tf)
  # println("size x $(size(x))")

   
   # sp2d = Dierckx.Spline2D(x,y,z,s=1000.)
   

   #lonlat = zip(x,y)
   #RBF(x,y,l) = exp(norm(x-y)^2/2*l^2 ) # could avoid square root here in norm

   #K    = [RBF(x1,x2,10) for x1 in lonlat, x2 in lonlat]  
   #q    = minres(K,z)
   #q    = K

   #val(lon,lat) = [RBF([lon lat],x,10) for x in lonlat] * q   

   #pcon = contour(lonrange,latrange,(x,y) -> val(x,y),fill=true,seriescolor= cgrad(ColorSchemes.RdBu_10.colors), clim=(-1.,1.) )


   PyPlot.figure(1) 
   PyPlot.clf() 
   PyPlot.scatter(x,y,marker="o",s=0.05,color="green")
   # pcon = contour(lonrange,latrange,(x,y) -> sp2d(x,y),fill=true,seriescolor= cgrad(ColorSchemes.RdBu_10.colors), clim=(-1.,1.) )
   PyPlot.tricontourf(x,y,z,collect(-1.0:0.01:1.0),  cmap="RdBu_r",alpha = 0.6,extend="both")
   PyPlot.title(unix2datetime(t))
   
   # PyPlot.set_cmap("RdBu")
   # PyPlot.set_clim(-0.5,0.5)
   PyPlot.colorbar()
   
    
   #println(maximum(z2))
   #mycolor(v) = v>20. ? "purple" : "green"
   #mysize(v) = v>20. ? 20.0  : 0.05
   #PyPlot.scatter(x,y,c=mycolor.(z2),s=mysize.(z2), marker="o")
   # scatter!(x,y,markersize=0.1,legend=false)
   PyPlot.savefig("$outdir/pyplot_s=$(s)_$(unix2datetime(t)).png",dpi=300)   
    # savefig("pyplot$(unix2datetime(t)).png")
   #frame(anim)
end 

# gif(anim, "/tmp/anim_fps15.gif", fps = 15)