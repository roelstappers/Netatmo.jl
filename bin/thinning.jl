
using Netatmo, DataFrames, Dates, Statistics, Plots


dtg       = Dates.DateTime(2019,08,22,00)
dtgend    = dtg+Dates.Day(2) 
dtgend    = dtg+Dates.Minute(10) 

timerange = [dtg,dtgend]
df = Netatmo.read(timerange,latrange=[50,80],lonrange=[0,50]) 
df[!,:lon]  = round.(df[!,:lon],digits=1)
df[!,:lat]  = round.(df[!,:lat],digits=1)
df[!,:time] = round.(unix2datetime.(df[!,:time_utc]),Dates.Hour(3))

# group dataframe by lat lon time and compute mean pressure

dfmean  = by(df,[:lat, :lon, :time], d -> mean(d[:pressure]))
dfmean2 = by(df,[:lat, :lon, :time], d -> nrow(d))

scatter(dfmean[:lon],dfmean[:lat],legend=false)

