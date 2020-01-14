
function Kasper(h)
   # ps: Surface Pressure
   # p0: Sea Level Pressure
   L = 0.0065  # K/m
   cp = 1007.  # J/(kg*K)
   T0 = 288.15  # K
   g = 9.82  # m/s**2
   M = 0.0289644  # kg/mol
   R = 8.31447  # J/(mol*K)

   return 1 / ((1 - L * h / T0)^(g * M / (R * L)))
end 

function Celine(h)
    altitude_coeff = Int(round(100000 / (( 288 - 0.0065 * h)/288)^5.255));
    return altitude_coeff / 100000 ;
end 

 
