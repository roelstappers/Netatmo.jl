import Netatmo
using Stheno

dtg    = Dates.DateTime(2019,06,26,18); 
dtgend = Dates.DateTime(2019,06,26,20); 

outdir = "/home/roels/fig4/"


latrange  = 59.5:0.01:60.5
lonrange  = 10.3:0.01:11.3
timerange = Dates.DateTime(dtg):Dates.Minute(1):Dates.DateTime(dtgend)

df = Netatmo.read(timerange, latrange=latrange, lonrange=lonrange)
