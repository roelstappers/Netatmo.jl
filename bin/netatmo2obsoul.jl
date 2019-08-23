#!/usr/bin/env julia

using Netatmo, Dates

fcint     = Hour(3)  # should read this from TOML or HarmonieConfig module
dtg       = Dates.DateTime(2019,05,01,12)
dtgend    = dtg+fcint 
timerange = dtg:Minute(10):dtgend

df = Netatmo.read(timerange)  # this read command should be called readnetatmo and be provided by a "PPI" module. 

io=open("OBSOUL","w")
println(io,"$(year(dtg))$(month(dtg))$(day(dtg)) $(hour(dtg))")    #   


stationqualityflag="1111"
numbody      = 1
siteinfo     = 100000 
obstype      =  1  #  1 = SYNOP  https://apps.ecmwf.int/odbgov/obstype/
codetype     = 14  # 14 = Automatic Land SYNOP 
vertco_type  =  2  #  2 = Geopotential height
vertco_type2 =  1  # what to put here
paramqcflag  = 2064
varno        = 110 # 110=surface pressure (NOTE: 107=station pressure)

for val in df     
    id, time_utc, lat, lon, alt, pressure = val # unpack
    obsval   = 100.0*pressure   # convert hPa to Pa
    dt       = unix2datetime(time_utc)
    yyyymmdd = "$(year(dt))$(month(dt))$(day(dt))"          # or  Dates.format(dt,"yyyymmdd") 
    hhmmss   = "$(hour(dt))$(minute(dt))$(second(dt))"    
    statid   = "'$(SubString.(id,10,17))'" # 10:17 is a random choice
    header   = [10014011 lat lon statid yyyymmdd hhmmss alt numbody stationqualityflag]
    body     = [varno vertco_type vertco_type2 obsval paramqcflag]
    numentrs = length(header) + length(body)
    write(io,numentrs) 
    write(io,join(header, " "))
    write(io,join(body," "))
    write(io,"\n\n")
end 
close(io)

exit(0)


# @hdr
    # statid is ODB only allows 8 char strings. The choice for index 10:17 is arbitrary.
    dfout[!,Symbol("lat@hdr:REAL")]                 = df[:,:lat] 
    dfout[!,Symbol("lon@hdr:REAL")]                 = df[:,:lon]
    dfout[!,Symbol("seqno@hdr:INTEGER")]            = df[:,:seqno] 
    dfout[!,Symbol("statid@hdr:STRING")]            .= SubString.(df[!,:id],10,17)
    dfout[!,Symbol("date@hdr:INTEGER")]             .= Dates.format.(datetime,"yyyymmdd") 
    dfout[!,Symbol("time@hdr:INTEGER")]             .= Dates.format.(datetime,"HHMMSS")     
    dfout[!,Symbol("obsvalue@hdr:REAL")]            .= 100.0*df[:,:pressure]   # Pressure in Pa
    dfout[!,Symbol("obstype@hdr:INTEGER")]          .= 1                     # 1=SYNOP
    dfout[!,Symbol("codetype@hdr:INTEGER")]         .= 11                    # 11=Manual land 
    dfout[!,Symbol("distribtype@hdr:INTEGER")]      .= 0
    
    # @body
    dfout[!,Symbol("varno@body:INTEGER")]           .= 110                   # 110=surface pressure (NOTE: 107=station pressure)
    dfout[!,Symbol("vertco_type@body:INTEGER")]     .= 2                     
    dfout[!,Symbol("vertco_reference_1@body:REAL")] .= 0.0
    dfout[!,Symbol("entryno@body:INTEGER") ]        .= 1                

    # @errstat 
    dfout[!,Symbol("obs_error@errstat:REAL")]       .= 0.1  

    # @conv 
    #dfout[!,Symbol("station_type@conv:INTEGER")]    .= 

    # @conv_body
    dfout[!,Symbol("ppcode@conv_body:INTEGER")]     .= 1                      # See ERA5 documentation            
    return dfout
end 