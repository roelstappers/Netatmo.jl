
struct Data
    time_utc::Int64
    Pressure::Float64        
    Temperature::Union{Missing,Float64}
    Humidity::Union{Missing,Int64} 
end 

struct NetatmoStation
    _id::String 
    Latitude::Float64
    Longitude::Float64
    Altitude::Float64   # note we require Altitude
end 

# Convenience function 
lon(nas::NetatmoStation)  = nas.Longitude
lat(nas::NetatmoStation)  = nas.Latitude
lat(alt::NetatmoStation)  = alt.Altitude

# Check if 2 netatmo station are equal (uses _id)
==(nas1::NetatmoStation,nas2::NetatmoStation) = nas1._id == nas2._id

# Coefficient to convert mslp2sp as used by Netatmo
mslp2sp_coeff(alt) = 1.0 / (Int(round(100000 / (( 288 - 0.0065 * alt) / 288)^5.255)) / 100000)

sp(nas::NetatmoStation) 







