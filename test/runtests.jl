
using Netatmo
using CSV



# csvfile="$(Netatmo.CSV_ARCHIVE)/2019/05/01/20190501T094501Z.csv"
csvfile="$(Netatmo.CSV_ARCHIVE)/2019/08/11/20190811T090502Z.csv"
filename, ext = splitext(basename(csvfile))
df = CSV.read(csvfile )
# df2 = Netatmo.df2df4odbimport(df)
# CSV.write("$(filename)_temp.csv",df2)   


using Test
@test 1 == 1
