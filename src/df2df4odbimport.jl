
"""

   dfout = df2df4odbimport(df)   

dfout is a dataframe in the "wide" format that can be used by odb import. 
See https://confluence.ecmwf.int/display/ODBAPI/Importing+CSV+data
"""
function df2df4odbimport(df)  
    
    df[:seqno] = 0                   # add integercolumn to store seqno
    groupedbyid = groupby(df,:id)
    for i in 1:length(groupedbyid,1) 
        groupedbyid[i][:seqno] = i         
    end
    
    dfout = DataFrames.DataFrame()

    datetime = Dates.unix2datetime.(df[:time_utc])

    # @hdr
    # statid is ODB only allows 8 char strings. The choice for index 10:17 is arbitrary.
    dfout[Symbol("statid@hdr:STRING")]            = SubString.(df[:id],10,17)
    dfout[Symbol("date@hdr:INTEGER")]             = Dates.format.(datetime,"yyyymmdd") 
    dfout[Symbol("time@hdr:INTEGER")]             = Dates.format.(datetime,"HHMMSS") 
    dfout[Symbol("lat@hdr:REAL")]                 = df[:lat] 
    dfout[Symbol("lon@hdr:REAL")]                 = df[:lon]
    dfout[Symbol("seqno@hdr:INTEGER")]            = df[:seqno] 
    dfout[Symbol("obsvalue@hdr:REAL")]            = 100.0*df[:pressure]   # Pressure in Pa
    dfout[Symbol("obstype@hdr:INTEGER")]          = 1                     # 1=SYNOP
    dfout[Symbol("codetype@hdr:INTEGER")]         = 11                    # 11=Manual land 
    dfout[Symbol("distribtype@hdr:INTEGER")]      = 0
    

    # @body
    dfout[Symbol("varno@body:INTEGER")]           = 110                   # 110=surface pressure (NOTE: 107=station pressure)
    dfout[Symbol("vertco_type@body:INTEGER")]     = 2                     # 2=Geopotential height
    dfout[Symbol("vertco_reference_1@body:REAL")] = 0.0
    dfout[Symbol("entryno@body:INTEGER") ]        = 1                

    # @errstat 
    dfout[Symbol("obs_error@errstat:REAL")]       = 0.1  

    # @conv 
    dfout[Symbol("station_type@conv:INTEGER")]    = 

    # @conv_body
    dfout[Symbol("ppcode@conv_body:INTEGER")]     = 1                      # See ERA5 documentation            
    return dfout
end 