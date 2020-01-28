module Netatmo

using DataFrames, DataStructures
using CategoricalArrays, CSV, JSON
using Glob, Dates, ProgressMeter, Statistics
# import Feather

export read
export json2csv
export @d_str
# export df2df4odbimport
# export csv2csv4odbimport

# const CSV_ARCHIVE    ="/lustre/storeB/users/roels/netatmo/csv"
const CSV_ARCHIVE    ="/media/roels/_disk2/Netatmo"
# const CSV_ARCHIVE    ="/home/roels/netatmo"
const FEATHER_ARCHIVE="/lustre/storeB/users/roels/netatmo/feather"
const JSON_ARCHIVE   ="/lustre/storeB/project/metproduction/products/netatmo/"

function __init__()
  isdir(CSV_ARCHIVE)  || error("Directory $CSV_ARCHIVE does not exist")
  isdir(JSON_ARCHIVE) || error("Cannot access $JSON_ARCHIVE")
  @show CSV_ARCHIVE
  @show JSON_ARCHIVE
end

include("d_str.jl")
include("read.jl")
include("json2csv.jl")
# include("json2feather.jl")
include("thin_randomselect.jl")
include("df2df4odbimport.jl")
include("thin.jl")
end
