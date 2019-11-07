"""

    json2feather(day::Date)

Read json data from Netatmo.JSON_ARCHIVE (lustre) and write csv data to Netatmo.FEATHER_ARCHIVE 

CSV columns are 
:id,:time_utc,round(:lat,digits=6),round(:lon,digits=6),:alt,:pressure,:temperature,:humidity,:sum_rain_1 
"""
function json2feather(cday::Date)

    YYYY = year(cday); 
    mm   = lpad(month(cday), 2, "0"); 
    DD   = lpad(day(cday), 2, "0")
    
    lustredir = "$JSON_ARCHIVE/$YYYY/$mm/$DD/"
    outputdir = "$FEATHER_ARCHIVE/$YYYY/$mm/$DD/"

    mkpath(outputdir)
    
    for jsonfile in glob("*Z.json", lustredir) 
        featherfile =  joinpath(outputdir, "$(splitext(basename(jsonfile))[1]).feather")
        json2csv(jsonfile,featherfile)
    end 
end

"""
   df = json2feather(jsonfile::String,featherfile::String)

Convert json to feather and return dataframe

"""
function json2feather(jsonfile::String,featherfile::String)
    println("reading $jsonfile") 
   
    !isfile(featherfile) || error("outputfile $featherfile exists already") 

    #replace needed because of invalid json files on lustre   
    jsonstring = replace(readline(jsonfile), "][" => ",")
      
    if isempty(jsonstring)  
       println("Empty json. skipping $jsonfile")
       return             
    end 

    if jsonstring == "[,,,,,,]" 
        println("Empty json. skipping $jsonfile")
        return
    end

    jdict = JSON.parse(jsonstring) 
    println("length jdict: $(length(jdict))")     
   
    df = DataFrames.DataFrame(
        id          = String[], 
        time_utc    = Int64[], 
        lat         = Float64[], 
        lon         = Float64[], 
        alt         = Float64[], # Could allow for missing values
        pressure    = Float64[], 
        temperature = Union{Float64,Missing}[],
        humidity    = Union{Float64,Missing}[],
        sum_rain_1  = Union{Float64,Missing}[])
    
    fltr(val) = haskey(val,"_id") &&
                haskey(val["data"],"time_utc") &&
                haskey(val,"location") &&
                haskey(val["data"], "Pressure") && 
                haskey(val, "altitude")

    for val in filter(fltr,jdict)

        id       = val["_id"]
        lon      = val["location"][1]   
        lat      = val["location"][2]
        pressure = val["data"]["Pressure"]
        time_utc = val["data"]["time_utc"]            
        alt      = val["altitude"]   
        
        # DefaultDict returns missing if key absent
        dd_val = DataStructures.DefaultDict(missing,val["data"])
        temperature = dd_val["Temperature"] 
        humidity    = dd_val["Humidity"]
        sum_rain_1  = dd_val["sum_rain_1"]      
        
        push!(df,[id,time_utc,lat,lon,alt,pressure,temperature,humidity,sum_rain_1])
    end   
    Feather.write(featherfile,df)  
    return df 
end
