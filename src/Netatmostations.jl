# Data field in we can not unmarshall this because the keys are time_utc
using JSON2

#struct Wind     
# end 


struct Data
    Temperature::Union{Float64,Missing}
    Humidity::Union{Int64,Missing}
    Pressure::Union{Float64,Missing}
    Rain::Union{Float64,Missing}    
    time_day_rain::Union{Float64,Missing}     
    wind::Any 
    wind_gust::Any
    sum_rain_1::Union{Float64,Missing}
    time_hour_rain::Union{Int64,Missing}
    time_utc::Union{Int64,Missing}
end 

Data(;Temperature=missing, 
       Humidity=missing,
       Pressure=missing,
       Rain=missing,
       time_day_rain=missing,
       wind=missing,
       wind_gust=missing,
       sum_rain_1=missing,
       time_hour_rain=missing,
       time_utc=missing)= Data(Temperature,Humidity, Pressure, Rain,time_day_rain,missing,missing,sum_rain_1, time_hour_rain, time_utc)

# Data() = Data(missing, missing,missing,missing, missing,missing, missing, missing, missing)


JSON2.@format Data keywordargs  begin
#     wind = (;exclude=false)
 end 
       

       # Data(T,H,P,time_utc) = Data(T,H,P,missing,missing,missing,missing,time_utc)
# Data(T,H,P,R,tdr,w,sr1,thr,tu) = Data(T,H,P,missing,missing,missing,missing,time_utc)

struct NetatmoRecord 
    location::Array{Float64,1}  # Lon lat 
    _id::String 
    data::Data
    altitude::Union{Missing,Float64 }
    modules::Union{Missing,Array{String,1}}
    # NetatmoRecord(location,_id,data,altitude,modules) = new(location,replace(_id,r"\/" => "//"),data,altitude,modules) 
end 
NetatmoRecord(;location=missing, _id=missing, data=missing, altitude=missing, modules=missing) = 
        NetatmoRecord(location,_id,data,altitude,modules)

JSON2.@format NetatmoRecord keywordargs begin
end 

str = replace(read("/home/roels/test2.json",String),"]\n[" => ",");
JSON2.read(str,NetatmoRecord[])
# NetatmoRecord(location,_id,data,altitude,modules) = NetatmoRecord(location,r"$_id",data,altitude,modules) 




