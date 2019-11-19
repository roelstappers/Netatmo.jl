
# This is probably not need and done by Netatmo
using Proj4
#export PROJ_LIB=/home/roels/.julia/packages/Proj4/UxvhB/deps/usr/share/proj
wgs84 = Projection("+proj=longlat +datum=WGS84 +no_defs")
geoid = Projection("+proj=vgridshift +grids=egm96_15.gtx")

f(x,y) = -transform(wgs84,geoid,[x, y, 0])[3]

# transform(wgs84,geoid,[10, 60, 0])

contourf(-180:0.1:179.5,-85:0.1:85,f, color=:RdBu_r,colorbar=:bottom)
