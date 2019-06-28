
# tests go here
using Netatmo
using CSV



csvfile="$(Netatmo.CSV_ARCHIVE)/2019/05/01/20190501T094501Z.csv"
filename, ext = splitext(basename(csvfile))
df = CSV.read(csvfile )
df2 = df2df4odbimport(df)
CSV.write("$(filename)_temp.csv",df2)   


using Test
@test 1 == 1
