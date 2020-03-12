using Netatmo, Plots, Dates, DataFrames

DTG = d"20190801"
DTGEND = d"20190810"

timerange = DTG:Dates.Hour(3):DTGEND

df = Netatmo.read_obsoul(timerange)

groups = groupby(df,:statid)

numrows = [nrow(g) for g in groups]

plot(numrows)