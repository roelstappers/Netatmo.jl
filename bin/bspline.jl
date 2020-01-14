#!/usr/bin/env julia

using Netatmo, Dates

# sp = mslp2sp_coeff(alt)*mslp 
# Equation provided by Celine Bensahla-Tani  
# We use this to undo the conversion to mslp from Netatmo
mslp2sp_coeff(alt) = 1.0 / (Int(round(100000 / (( 288 - 0.0065 * alt) / 288)^5.255)) / 100000)


trange = Dates.DateTime(2019, 08, 01, 00):Dates.Hour(3):Dates.DateTime(2019, 08, 02, 00) 
df = Netatmo.read(trange, latrange = [50,80], lonrange = [0,50]) 

groups= groupby(df,:id)


