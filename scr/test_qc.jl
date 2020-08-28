using Netatmo, Plots, Dates, DataFrames

DTG = d"20190801"
DTGEND = d"20190802"

timerange = DTG:Dates.Hour(3):DTGEND

df = Netatmo.read(timerange)
groups = groupby(df,:id)

for group in groups
     
end