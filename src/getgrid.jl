function getgrid(stepsize)

"""
     Returns lon lat coordinates based on a regular grid created in the Lambert conformal conic projection
     `stepsize` is the gridspacing in meters 
"""

# For now we fix the domain should read this from config_exp.h
    METCOOP25C = (NLAT = 960,
    LONC = 16.763011639,
    TSTEP = 75,
    GSIZE = 2500.0,
    LON0 = 15.0,
    LATC = 63.489212956,
    LAT0 = 63.0,
    NLON = 900, 
    EZONE = 11)

    dom  = METCOOP25C
    Plonlat = Projection("+proj=longlat +R=$Rearth")
    Plcca   = Projection("+proj=lcca    +R=$Rearth +lat_0=$(dom.LAT0) +lon_0=$(dom.LON0) ")

    lcca2lonlat(xy)     = transform(Plcca, Plonlat, xy)
    lonlat2lcca(lonlat) = transform(Plonlat, Plcca, lonlat)

    (xc, yc) = lonlat2lcca([dom.LONC, dom.LATC])

    west  = xc - dom.GSIZE * (dom.NLON - dom.EZONE - 1) / 2
    south = yc - dom.GSIZE * (dom.NLAT - dom.EZONE - 1) / 2
    east  = xc + dom.GSIZE * (dom.NLON - dom.EZONE - 1) / 2
    north = yc + dom.GSIZE * (dom.NLAT - dom.EZONE - 1) / 2

    xs = range(west,  step = stepsize, stop = east) 
    ys = range(south, step = stepsize, stop = north) 

    lonlats = []
    for x in xs
        for y in ys        
            push!(lonlats, lcca2lonlat([x,y]))
        end 
    end 

    return lonlats
end 