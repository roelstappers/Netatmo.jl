#!/usr/bin/env julia

using Netatmo, Dates

fcint     = Hour(3)  # should read this from TOML or HarmonieConfig module
dtg       = Dates.DateTime(2019,05,01,12)
dtgend    = dtg+fcint 
timerange = dtg:Hour(3):dtgend

df = Netatmo.read(timerange,latrange=range(60,60.01,length=2))  # this read command should be called readnetatmo and be provided by a "PPI" module. 

stqualityflag      = 1111
numbody            = 1   
stationinfo        = 100000 
obstype            =  1     #  1 = SYNOP  https://apps.ecmwf.int/odbgov/obstype/
codetype           = 14     # 14  = Automatic Land 
vertco_reference_2 = 0.1699999976E+39     #  missing value 
paramqcflag        = 2064
varno              = 110    # 110=surface pressure (NOTE: 107=station pressure)
KNCMOCH            = "$codetype"   # see oulan_carobs.F90


io=open("OBSOUL","w")
println(io,"$(year(dtg))$(month(dtg))$(day(dtg)) $(hour(dtg))")    #   

for val in eachrow(df)      
    id, time_utc, lat, lon, alt, pressure = val # unpack
    obsval   = 100.0*pressure   # convert hPa to Pa
    dt       = unix2datetime(time_utc)
    yyyymmdd = "$(year(dt))$(month(dt))$(day(dt))"          # or  Dates.format(dt,"yyyymmdd") 
    hhmmss   = "$(hour(dt))$(minute(dt))$(second(dt))"    
    statid   = "'$(SubString(id,10,17))'" # 10:17 is a random choice
    header   = Any[obstype KNCMOCH lat lon statid yyyymmdd hhmmss alt numbody stqualityflag stationinfo]
    body     = Any[varno obsval vertco_reference_2  alt  paramqcflag]
    numentrs = length(header) + length(body) + 1
    print(io,"$numentrs ") 
    print(io,join(header, " "))
    println(io,join(body," "))    
end 
close(io)
end 