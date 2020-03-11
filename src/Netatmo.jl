module Netatmo

using DataFrames, DataStructures
using CategoricalArrays, CSV, JSON
using Glob, Dates, ProgressMeter, Statistics
# import Feather

export read
export json2csv
export @d_str

const DIR = @__DIR__

const archives = JSON.parsefile("$DIR/config/$(gethostname()).json")
const CSV_ARCHIVE    = archives["CSV_ARCHIVE"]    # "/media/roels/_disk2/Netatmo"
const JSON_ARCHIVE   = archives["JSON_ARCHIVE"]   # "/lustre/storeB/project/metproduction/products/netatmo/"
const OBSOUL_ARCHIVE = archives["OBSOUL_ARCHIVE"] # "/media/roels/_disk2/OBSOUL/"

function __init__()
  isdir(CSV_ARCHIVE)  || error("Directory $CSV_ARCHIVE does not exist")
  isdir(JSON_ARCHIVE) || error("Cannot access $JSON_ARCHIVE")
  @show CSV_ARCHIVE
  @show JSON_ARCHIVE
  @show OBSOUL_ARCHIVE
end

struct NAObs{T}
  Humidity::T
  Pressure::T   #MSLP as calculated by Netatmo  
    
  Rain{T} 

end 

include("d_str.jl")
include("read.jl")
include("json2csv.jl")
# include("json2feather.jl")
include("thin_randomselect.jl")
include("read_obsoul.jl")
include("thin_togrid.jl")
# include("getgrid.jl")
end
