using Proj4, GMT, Makie

# get grid with stepsize = 20km 
lonlats  = getgrid(20000.)

lons =  getindex.(lonlats,1) 
lats =  getindex.(lonlats,2) 

scatter(lons,lats)

          






