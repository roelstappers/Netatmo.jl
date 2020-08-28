#!/usr/bin/env julia

"""
See http://www.rclace.eu/File/Data_Assimilation/2007/lace_obspp.pdf
"""


using Netatmo, Dates

# sp = mslp2sp_coeff(alt)*mslp 
# Equation provided by Celine Bensahla-Tani  
# We use this to undo the conversion to mslp from Netatmo
mslp2sp_coeff(alt) = 1.0 / (Int(round(100000 / (( 288 - 0.0065 * alt) / 288)^5.255)) / 100000)


trange = Dates.DateTime(2019, 07, 09, 00):Dates.Hour(3):Dates.DateTime(2019, 09, 01, 00) 
for dtgmid in trange
    # dtgmid    = Dates.DateTime(2019,08,22,03)
    dtgbeg    = dtgmid - Dates.Minute(90)
    dtgend    = dtgmid + Dates.Minute(90) 
    timerange = [dtgbeg, dtgend] 

    # df = Netatmo.read(timerange,latrange=range(60,60.01,length=2)) 
    @info "Reading: $timerange"
    df = Netatmo.read(timerange, latrange = [50,80], lonrange = [0,50]) 

    @info "Thinning to grid"
    dfthinned = Netatmo.thin_togrid(df)

    @info "Thinning finished"
    stqualityflag      = 1111
    numbody            = 1   
    stationinfo        = 100000 
    obstype            = 1     #  1 = SYNOP  https://apps.ecmwf.int/odbgov/obstype/
    codetype           = 199      # 199 = new codetype, 14  = Automatic Land 
    vertco_reference_2 = 0.1699999976E+39     #  missing value 
    paramqcflag        = 2048   
    varno              = 110    # 110=surface pressure (NOTE: 107=station pressure)
    KNCMOCH            = "$codetype"   # see oulan_carobs.F90


    yyyymmdd = Dates.format(dtgmid, "yyyymmdd") 
    HH = Dates.format(dtgmid, "HH") 

    io = open("OBSOUL$yyyymmdd$HH", "w")
    println(io, "$yyyymmdd $HH")    #   
    g0 = 9.81 

    for val in eachrow(dfthinned)      
    # id, time_utc, lat, lon, alt, pressure = val # unpack
    # time     = val[:time] 
        lat      = val[:lat]
        lon      = val[:lon]
        pressure = val[:pressure]
        alt      = val[:alt]
        id       = val[:id]

        obsval   = mslp2sp_coeff(alt) * 100 * pressure   # convert hPa to Pa and convert to surface pressure
    #  dt       = time   #unix2datetime(time_utc)    
        yyyymmdd = Dates.format(dtgmid, "yyyymmdd") 
        hmmss    = Dates.format(dtgmid, "HMMSS")      # No leading zero for HH
        statid   = "'$(SubString(id,10,17))'" # 10:17 is a random choice
        latid    = lpad(Int(round(10 * lat)), 3, "0")
        lonid    = lpad(Int(round(10 * lon)), 3, "0")
        # statid   = "'NA$latid$lonid'"
        header   = Any[obstype, KNCMOCH, lat, lon, statid, yyyymmdd, hmmss, alt, numbody, stqualityflag, stationinfo]
        body     = Any[varno, g0 * alt, vertco_reference_2,  obsval,  paramqcflag]
        numentrs = length(header) + length(body) + 1
        println(io, join([numentrs; header; body], " "))
    
    end
    close(io)
end 
