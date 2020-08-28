module Netatmo

using DataFrames, DataStructures
using CategoricalArrays, CSV, JSON, Distances
using Glob, Dates, ProgressMeter, Statistics, NearestNeighbors
using Domains
# import Feather

export read
export json2csv
export @d_str

const DIR = @__DIR__



function __init__()  
  global archives = JSON.parsefile("$DIR/config/config.json")
  global CSV_ARCHIVE    = archives["CSV_ARCHIVE"]    # "/media/roels/_disk2/Netatmo"
  global JSON_ARCHIVE   = archives["JSON_ARCHIVE"]   # "/lustre/storeB/project/metproduction/products/netatmo/"
  global OBSOUL_ARCHIVE = archives["OBSOUL_ARCHIVE"] # "/media/roels/_disk2/OBSOUL/"
  isdir(JSON_ARCHIVE) || error("Cannot access $JSON_ARCHIVE")
  @show CSV_ARCHIVE
  @show JSON_ARCHIVE
  @show OBSOUL_ARCHIVE
end


include("d_str.jl")
include("read.jl")
include("json2csv.jl")
# include("json2feather.jl")
# include("thin_randomselect.jl")
include("read_obsoul.jl")
include("thin_togrid.jl")
# include("getgrid.jl")
end
