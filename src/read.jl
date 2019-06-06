"""
   `df = read(timerange)`

Returns dataframe with all Netatmo data in timerange 

   `df = read(timerange, latrange=latrange,lonrange=lonrange)`` 

Returns dataframe restricted to `latrange` `lonrange`. 

The returned Dataframe has columns

   `df = DataFrames.DataFrame(id = String[], time_utc = Int64[], lat = Float64[], lon = Float64[], 
                alt=Union{Float64,Missing}[], 
                pressure = Float64[], 
                temperature=Union{Float64,Missing}[],
                humidity=Union{Float64,Missing}[],
                sum_rain_1=Union{Float64,Missing}[])`
"""
function read(timerange; latrange=[-90., 90.], lonrange=[-180., 180.])
    
    length(latrange) >= 2            || error("length(latrange) < 2")
    length(lonrange) >= 2            || error("length(lonrange) < 2")
    lonrange[1] >= -180.             || error("lonrange[1] < -180.")
    lonrange[end] <= 180.            || error("lonrange[end] > 180.")
    latrange[1]  >= -90.             || error("latrange[1] < -90.")
    latrange[end] <= 90.             || error("latrange[end] > 90.")
    minute(timerange[1]) % 10   == 0 || error("minute(timerange[1]) % 10 != 0 ")
    second(timerange[1])        == 0 || error("second(timerange[1]) != 0 ")
    minute(timerange[end]) % 10 == 0 || error("minute(timerange[end]) % 10 != 0 ")
    second(timerange[end])      == 0 || error("second(timerange[end]) != 0 ")
    
    
    df = DataFrames.DataFrame(id = String[], time_utc = Int64[], lat = Float64[], lon = Float64[], 
                              alt=Union{Float64,Missing}[], 
                              pressure = Float64[], 
                              temperature=Union{Float64,Missing}[],
                              humidity=Union{Float64,Missing}[],
                              sum_rain_1=Union{Float64,Missing}[])

    

    # filename are stored every 5 + 10*k minutes so we shift 5 minutes 
    # We shift end point +Minute(10) to add "late" observations  (+Minute(20)  would add little )
    for cdate in timerange[1]+Minute(5):Minute(10):timerange[end]+Minute(5)+Minute(10)
        YYYY = year(cdate) 
        mm   = lpad(month(cdate), 2, "0") 
        DD   = lpad(day(cdate), 2, "0")
        HH   = lpad(hour(cdate), 2,"0")
        MM   = lpad(minute(cdate),2,"0")
       
        file = glob("$YYYY$mm$(DD)T$HH$MM*.csv","$NETATMO_CSV_ARCHIVE/$YYYY/$mm/$DD/")
        if !isempty(file) 
          println("Appending $file")
          append!(df,CSV.read(file[1]))
        else 
          println("Missing csv file for $cdate")
        end
    end 

    # For some observations the time_utc doesn't get updated.
    # Here we remove all observations with the same :id and :time_utc
    # We only want to keep the first observation (which has the correct time_utc)
    # Does unique guarantee this?
    unique!(df,[:id, :time_utc])

    timemin = datetime2unix(timerange[1])
    timemax = datetime2unix(timerange[end])

    latfilter(row)  = latrange[1]  <= row[:lat]      <= latrange[end] 
    lonfilter(row)  = lonrange[1]  <= row[:lon]      <= lonrange[end] 
    timefilter(row) = timemin      <= row[:time_utc] <= timemax 

    totfilter(row) = lonfilter(row) .& latfilter(row) .& timefilter(row)
    
    filter!(totfilter,df) 
    
    return df
    # quick fix use mean instead of moving average
    #groupbyid = DataFrames.by(df,:id,mean=:pressure => DataFrames.mean)

    #dfout = DataFrames.DataFrame(time_utc = Int64[], lat = Float64[], lon = Float64[], pressure = Float64[])
    


    #groupbyid = DataFrames.by(df,:id,var=:pressure => DataFrames.var)

    # Exclude stations where the variance of pressure is either NaN, >10 hPa or 0 hPa 
    #badids = groupbyid[:id][(isnan.(groupbyid[:var]) .| (groupbyid[:var] .> 10)) .| (groupbyid[:var] .== 0.)]
    #println("Removed $(length(badids)) stations based on pressure variance")   
    #filter!(row -> !(row.id in badids),df)
    
    # remove  stations with too few observatiosn 
    # groupbylength = DataFrames.by(df,:id,N=:id => length)
    # df = df[ groupbylength .>= mindata,:]
end