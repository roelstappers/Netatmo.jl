
using Netatmo, Dates, Statistics, Plots


dtg       = Dates.DateTime(2019,08,22,00)
dtgend    = dtg+Dates.Day(2) 

timerange = [dtg,dtgend]
df = Netatmo.read(timerange,latrange=[50,80],lonrange=[0,50]) 
df[!,:lon]  = round.(df[!,:lon],digits=1)
df[!,:lat]  = round.(df[!,:lat],digits=1)
df[!,:time] = round.(unix2datetime.(df[!,:time_utc]),Dates.Hour(3))

# group dataframe by lat lon time and compute mean pressure
function mymean(d)
    if size(d,1) > 10
        mean(d[:pressure])
    else
        nothing
    end 

end 

dfmean = by(df,[:lat, :lon, :time],  d -> mean(d[:pressure]))
dfmean2 = by(df,[:lat, :lon, :time], d -> size(d,1))

scatter[dfmean[:lon],dfmean[:lat],legend=false)

