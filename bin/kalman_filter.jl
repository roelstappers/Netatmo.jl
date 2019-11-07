#!/usr/bin/env julia

using Netatmo, Dates, NamedArrays, LinearAlgebra, Unitful

 
σₒ  = 0.1u"hPa"   #Observation error
σb  = 1e-6u"hPa"  # std of bias between cycles 
σdp = 0.1u"hPa"   # std of pressure departure 
  
trange = Dates.DateTime(2019,08,22,03):Dates.Hour(3): Dates.DateTime(2019,08,24,03) 

# for now (for simplicity) the stations available in the first 10 minutes will be used for the KF
df = Netatmo.read([trange[1], trange[1]+Minute(10)],latrange=[50,60],lonrange=[0,10])

# Some stations might report twice in 10 minutes. Only keep unique ids
station_ids = unique(df[:,:id])
n = length(station_ids) 

# Note we decompose the observed pressures as  ps = b + dp 
# state space is [b, dp]  twice the size of the number of observations
# append "b" "dp"  to create unique id for "b" and "dp" part of state
state_ids = [station_ids .* "b"; station_ids .*"dp"]   


# Initial estimate for "state" error covariance matrix. 
P = NamedArray(Matrix(1e3I,2*n,2*n),(state_ids,state_ids))

# Observation operator H=[I I] 
H = NamedArray(Matrix([I I],n,2n), (station_ids,state_ids))

# Observations error covariance 
R = NamedArray(Matrix(σₒ^2*I,n,n),(station_ids,station_ids))


Q = NamedArray(Matrix([σb^2*I zero(n,n); σdp^2*I zero(n,n),2*n,2*n]),(station_ids,station_ids))

# The model propagator for ["b" "b"]  and "dp" is the identity. So we skip it 




