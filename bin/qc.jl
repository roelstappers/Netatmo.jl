
using Netatmo, DataFrames, Dates, Statistics, Plots, Distances, NearestNeighbors

Rearth= 6.371e6
dtg       = Dates.DateTime(2019,08,22,00)
dtgend    = dtg+Dates.Day(1) 
# dtgend    = dtg+Dates.Minute(10) 

timerange = [dtg,dtgend]
df = Netatmo.read(timerange,latrange=[50,80],lonrange=[0,50]) 
df[!,:lon]  = round.(df[!,:lon],digits=1)
df[!,:lat]  = round.(df[!,:lat],digits=1)
df[!,:time] = round.(unix2datetime.(df[!,:time_utc]),Dates.Minute(10))

groups = groupby(df,:id)

lat = [g[1,:lat] for g in groups]
lon = [g[1,:lon] for g in groups]
kdtree = BallTree(collect([lon lat]'),Haversine(Rearth); leafsize = 10)

# find points closest to grid and compare 
indices, dist = knn(kdtree,[10, 60],50,true)

function getpressure(g,time)
    val = g[g[!,:time] .== time,:pressure]
    isempty(val) ?  nothing : val[1]
end

getpres(g) = map(x -> getpressure(g,x),timerange)

subgr = groups[indices]
correl = [cor(getpres(g),getpres(h)) for g in subgr, h in subgr]
 

# 
unstacked = unstack(df,:time, :id,:pressure)  

#function getpressure(df)
    
    # mask = df[!,:id] .== id 
  
    # stat = df[mask,[:pressure,:time]]
#    timerange = dtg:Dates.Minute(10):dtgend
#    dummy = DataFrames.DataFrame(time=timerange)
#    out = join(dummy, copy(df), on=:time,kind=:left)
#    return out[!,:pressure]
    
# end 

p1 = getpressure(groups[1]); p1c = coalesce.(p1,0.0)
p2 = getpressure(groups[2]); p2c = coalesce.(p2,0.0)

# p1 = α*p2
α = (p2c'*p2c)^-1 * p1c'*p2c

scatter(p1, α*p2)


scatter(dfmean[:lon],dfmean[:lat],legend=false)

