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
kdtree = BallTree(collect([lon lat]'),Haversine(Rearth); leafsize = 10)

#

# Add  a column :time_utc_round for easy regression

unstack(df[:,[:id,:pressure,:time_utc_round]],:id,:pressure)


indices, dist = knn(kdtree,[10, 60 ],50)
indices, dist = knn(kdtree,[10.74609, 59.91273],5)

substack = unstack(df[:,[:id,:pressure,:time_utc_round]],:id,:pressure)


plot(legend=false)
for g in groups[indices]
    plot!(unix2datetime.(g[!,:time_utc]),g[!,:pressure])
    #dftemp = filter(row -> row[:id] == ids[index,:id],df)
    #if !any(ismissing.(dftemp[:,:temperature]))
#        plot!(unix2datetime.(dftemp[!,:time_utc]),dftemp[!,:temperature])
    #end
end
title!("Pressure")


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
