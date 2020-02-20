using DataFrames, Dates, Plots, NearestNeighbors, Distances
import Netatmo

Rearth = 6.371e6

dtg = Dates.DateTime(2018,05,10,00)
period = Dates.Hour(24)
timerange = dtg:Minute(10):(dtg+period)

df = Netatmo.read(timerange, latrange=[50,70], lonrange=[0,20])

ids = unique(df,:id)
df[!,:time_utc_round] = round.(unix2datetime.(df[!,:time_utc]),Dates.Second(10))
groups= groupby(df,:id)

lat = [g[1,:lat] for g in groups]
lon = [g[1,:lon] for g in groups]
varg = [var(g[:,:pressure]) for g in groups]

mask = (varg .<50) .& (.!isnan.(varg))
lat = lat[mask]
lon  = lon[mask]
varg = varg[mask]

high = varg.>10
low = varg.<10
scatter(lon[high],lat[high],color=:red)
scatter!(lon[low],lat[low],color=:blue)




