"""

    json2csv(day::Date)

Read json data from Netatmo.JSON_ARCHIVE (lustre) and write csv data to Netatmo.CSV_ARCHIVE 

CSV columns are 
:id,:time_utc,round(:lat,digits=6),round(:lon,digits=6),:alt,:pressure,:temperature,:humidity,:sum_rain_1 
"""
function json2csv(cday::Date)

    YYYY = year(cday); 
    mm   = lpad(month(cday), 2, "0"); 
    DD   = lpad(day(cday), 2, "0")
    
    lustredir = "$JSON_ARCHIVE/$YYYY/$mm/$DD/"
    outputdir = "$CSV_ARCHIVE/$YYYY/$mm/$DD/"

    mkpath(outputdir)
    
    for jsonfile in glob("*Z.json", lustredir) 
        csvfile =  joinpath(outputdir, "$(splitext(basename(jsonfile))[1]).csv")
        json2csv(jsonfile,csvfile)
    end 
end

"""
   df = json2csv(jsonfile::String,csvfile::String)

Convert jsonfile to csvfile and return dataframe

"""
function json2csv(jsonfile::String,csvfile::String)
    println("reading $jsonfile") 
   
    !isfile(csvfile) || error("outputfile $csvfile exists already") 

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
    
    for val in jdict

        if haskey(val, "_id") 
            id  = val["_id"]
        else
            println("Skipping: missing _id.")
            continue 
        end        
        if haskey(val,"location")
            lon = val["location"][1]   
            lat = val["location"][2]
        else
            println("Skipping: missing location")
            continue
        end
        if haskey(val["data"], "Pressure") 
            pressure    = val["data"]["Pressure"]
        else 
            # println("Skipping: missing pressure in $id")            
            continue
        end
        if haskey(val["data"],"time_utc")
            time_utc    = val["data"]["time_utc"]            
        else
            println("Skipping: missing time_utc")
            continue
        end
        
        # Should we continue if mising Alti
        if haskey(val, "altitude")
            alt    = val["altitude"]   
        else 
            # error("missing altitude $id") 
            # println("missing altitude: $id")
            continue 
        end

        # DefaultDict returns missing if key absent
        dd_val = DataStructures.DefaultDict(missing,val["data"])
        temperature = dd_val["Temperature"] 
        humidity    = dd_val["Humidity"]
        sum_rain_1  = dd_val["sum_rain_1"]      
        
        push!(df,[id,time_utc,lat,lon,alt,pressure,temperature,humidity,sum_rain_1])
    end   
    CSV.write(csvfile,df)  
    return df 
end
