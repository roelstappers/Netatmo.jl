module Netatmo

using DataFrames, DataStructures
using CategoricalArrays, CSV, JSON
using Glob, Dates, ProgressMeter, Statistics
# import Feather

export read
export json2csv
export @d_str

const DIR = @__DIR__


# const CSV_ARCHIVE    ="/lustre/storeB/users/roels/netatmo/csv"
const archives = JSON.parsefile("$DIR/$(gethostname()).json")
const CSV_ARCHIVE    = archives["CSV_ARCHIVE"] # "/media/roels/_disk2/Netatmo"
# const CSV_ARCHIVE    ="/home/roels/netatmo"
# const FEATHER_ARCHIVE="/lustre/storeB/users/roels/netatmo/feather"
const JSON_ARCHIVE   = archives["JSON_ARCHIVE"] # "/lustre/storeB/project/metproduction/products/netatmo/"
const OBSOUL_ARCHIVE   = archives["OBSOUL_ARCHIVE"] # "/media/roels/_disk2/OBSOUL/"

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
include("read_obsoul.jl")
include("thin.jl")
end
