
# tests go here
using Netatmo



csvfile="$(Netatmo.CSV_ARCHIVE)/2019/05/01/20190501T094501Z.csv"
csv2csv4odbimport(csvfile)


using Test
@test 1 == 1
