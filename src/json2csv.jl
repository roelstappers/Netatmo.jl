function json2csv(timerange)

for cdate in timerange

    YYYY = year(cdate); 
    mm   = lpad(month(cdate), 2, "0"); 
    DD   = lpad(day(cdate), 2, "0")
    
    lustredir = "$JSON_ARCHIVE/$YYYY/$mm/$DD/"
    outputdir = "$CSV_ARCHIVE/$YYYY/$mm/$DD/"

    mkpath(outputdir)
    blacklist=String[]
    for filename in glob("*Z.json", lustredir) 
        
        print("reading $filename\n") 

        s = readline(filename);
        outputfile =  joinpath(outputdir, splitext(basename(filename))[1] * ".csv")
        !isfile(outputfile) || error("outputfile $outputfile exists already") 

        #replace needed because of invalid json files on lustre   
        jsonstring = replace(s, "][" => ",")
        
        io = open(outputfile, "a")         
        write(io, "id,time_utc,lat,lon,alt,pressure,temperature,humidity,sum_rain_1\n")
        
        if isempty(jsonstring)  
            println("Empty json. skipping $filename")
            continue            
        end 

        if jsonstring == "[,,,,,,]" 
            println("Empty json. skipping $filename")
            continue
        end

        jdict = JSON.parse(jsonstring)  
        for val in jdict
            if haskey(val, "_id") 
                id  = val["_id"]
            else
                println("Skipping: missing _id.")
                continue 
            end
            if val["_id"] in blacklist
                println("Skipping: blacklisted station $(val["_id"])")
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
                continue
            end
            if haskey(val["data"],"time_utc")
                time_utc    = val["data"]["time_utc"]
            else
                continue
            end            

            if haskey(val["data"], "Temperature")
               temperature= val["data"]["Temperature"]
            else
               temperature = ""                
            end

            if haskey(val["data"], "Humidity")
                humidity = val["data"]["Humidity"]
            else 
                humidity = ""
            end

            if haskey(val, "altitude")
               alt    = val["altitude"]   
            else 
                alt    = ""
            end

            if haskey(val,"sum_rain_1")
              sum_rain_1 = val["sum_rain_1"]
            else
              sum_rain_1 = ""
            end
                   
            write(io, "$id,$time_utc,$(round(lat,digits=6)),$(round(lon,digits=6)),$alt,$pressure,$temperature,$humidity,$sum_rain_1\n")            
        end         
        close(io)
    end 
end
end

