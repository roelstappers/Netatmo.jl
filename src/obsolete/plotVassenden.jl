

using Netatmo
using Dates
using DataFrames
using Plots

latc=61.492980
lonc=6.110930
delta = 0.05


latrange = latc-delta:0.01:latc+delta; lonrange=lonc-delta:0.01:lonc+delta

dtg = Dates.DateTime(2019,07,30,12); 
dtgend = Dates.DateTime(2019,07,30,24); 

timerange = Dates.DateTime(dtg):Dates.Minute(1):Dates.DateTime(dtgend)
df = Netatmo.read(timerange, latrange=latrange, lonrange=lonrange)

grouped = groupby(df,:id)

p = plot()

for g in grouped 
   plot!(p,unix2datetime.(g[:time_utc]),g[:pressure],legend=false)
   scatter!(p,unix2datetime.(g[:time_utc]),g[:pressure],marker=:o,markersize=1,legend=false)
end 
p 