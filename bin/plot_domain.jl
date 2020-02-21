using Plots
using Netatmo

# get grid with stepsize = 20km 
lonlats  = getgrid(20000.)

lons =  getindex.(lonlats,1) 
lats =  getindex.(lonlats,2) 

scatter(lons,lats)

          






