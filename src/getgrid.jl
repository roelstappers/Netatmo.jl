function getgrid(stepsize)

    """
     Returns lon lat coordinates based on a regular grid created in 
     the Lambert conformal conic alternative (lcca) projection
     `stepsize` is the grid spacing in meters 
"""

# For now we fix the domain should read this from config_exp.h
    METCOOP25C = (NLAT = 960, NLON=900, LONC = 16.763011639, LATC = 63.489212956,
                  TSTEP = 75, GSIZE = 2500.0, LON0 = 15.0, LAT0 = 63.0, EZONE = 11)

    dom  = METCOOP25C

    nlon, nlat = dom.NLON, dom.NLAT
    lon0, lat0 = dom.LON0, dom.LAT0
    lonc, latc = dom.LONC, dom.LATC
    gsize, ezone = dom.GSIZE, dom.EZONE

    Plonlat = Proj4.Projection("+proj=longlat +R=$Rearth")
    Plcca   = Proj4.Projection("+proj=lcca    +R=$Rearth +lat_0=$lat0 +lon_0=$lon0")

    lcca2lonlat(xy)     = Proj4.transform(Plcca, Plonlat, xy)
    lonlat2lcca(lonlat) = Proj4.transform(Plonlat, Plcca, lonlat)

    (xc, yc) = lonlat2lcca([lonc, latc])

    west  = xc - gsize * (nlon  -ezone - 1) / 2
    south = yc - gsize * (nlat - ezone - 1) / 2
    east  = xc + gsize * (nlon - ezone - 1) / 2
    north = yc + gsize * (nlat - ezone - 1) / 2

    xs = range(xc,  step = stepsize, stop = east) 
    ys = range(south, step = stepsize, stop = north) 

    lonlats = [lcca2lonlat([x,y]) for x in xs for y in ys] 

    return lonlats
end 