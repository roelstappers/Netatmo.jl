
function csv2csv4odbimport(filename_csv)
    filename, ext = splitext(basename(filename_csv))
    df = CSV.read(filename_csv)
    df2 = df2df4odbimport(df)
    CSV.write("$(filename)_temp.csv",df2)   
end


"""

   dfout = df2df4odbimport(df)   

dfout is a dataframe in the "wide" format that when converted to CSV can be . See
https://confluence.ecmwf.int/display/ODBAPI/Importing+CSV+data
"""
function df2df4odbimport(df)    
    dfout = DataFrames.DataFrame()

    # @hdr
    # ODB only allows 8 char strings. The choice for index 10:17 is arbitrary.
    dfout[Symbol("statid@hdr:INTEGER")]           = SubString.(df[:id],10,17) # do we need this
    dfout[Symbol("date@hdr:INTEGER")]             = Dates.format.(unix2datetime.(df[:time_utc]),"yyyymmdd") 
    dfout[Symbol("time@hdr:INTEGER")]             = Dates.format.(unix2datetime.(df[:time_utc]),"HHMMSS") 
    dfout[Symbol("lat@hdr:REAL")]                 = df[:lat] 
    dfout[Symbol("lon@hdr:REAL")]                 = df[:lon]
    dfout[Symbol("obsvalue@hdr:REAL")]            = 100.0*df[:pressure]   # Pressure in Pa
    dfout[Symbol("obstype@hdr:INTEGER")]          = 1                     # 1=SYNOP
    dfout[Symbol("codetype@hdr:INTEGER")]         = 11                    # 11=Manual land 
    dfout[Symbol("distribtype@hdr:INTEGER")]      = 0
    dfout[Symbol("seqno@hdr:INTEGER")]            = 1:size(df,1)

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
    dfout[Symbol("ppcode@conv_body:INTEGER")]     = 1    # Is this necessary (e.g. as in ERA5 documentation)            
    return dfout
end 