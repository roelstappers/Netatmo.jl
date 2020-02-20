
using CSV, Dates


#function read_obsoul(filename::String)
#  # this currently only works if numbody=1 
#    header  = ["obstype","KNCMOCH", "lat", "lon","statid","yyyymmdd","hmmss","alt","numbody","stqualityflag","stationinfo"]
#    body    = ["varno", "g0 * alt", "vertco_reference_2", "obsval","paramqcflag"]

#    CSV.read(filename, skipto = 2, delim = " ", header = ["numentrs"; header; body])
#end 

function read_obsoul(timerange::StepRange{DateTime,Hour})
    
    df = DataFrames.DataFrame(numentr = Int[],
              obstype = Int[],
              KNCMOCH = Int[],
              lat = Float64[],
              lon = Float64[],
              statid = String[],
              yyyymmdd = Int[],
              hmmss = Int[],
              alt = Float64[],
              numbody = Int[],
              stqualityflag = Int[],
              stationinfo = Int[],
              varno = Int[],
              geopotential = Float64[], 
              vertco_reference_2 = Float64[], 
              obsval = Float64[],
              paramqcflag = Int[])

  
   
    @showprogress "Reading: OBSOUL files " for cdate in timerange

        YYYY = year(cdate)
        mm   = lpad(month(cdate), 2, "0")
        DD   = lpad(day(cdate), 2, "0")
        HH   = lpad(hour(cdate), 2, "0")
        MM   = lpad(minute(cdate), 2, "0")
        OBSOUL_ARCHIVE = "/media/roels/_disk2/OBSOUL"
        filename = "$OBSOUL_ARCHIVE/OBSOUL$YYYY$mm$DD$HH"  
        dft = CSV.read(filename, skipto = 2, delim = " ", header = 0) 
        names!(dft, names(df))        
        append!(df, dft)           
    end
    return df
end




