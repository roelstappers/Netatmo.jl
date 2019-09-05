module Netatmo

import DataFrames, DataStructures
using CategoricalArrays, CSV, JSON
using Glob, Dates, ProgressMeter

export read
export json2csv
export df2df4odbimport
export csv2csv4odbimport

CSV_ARCHIVE="/lustre/storeB/users/roels/netatmo/"
JSON_ARCHIVE="/lustre/storeB/project/metproduction/products/netatmo/"

function __init__()
  isdir(CSV_ARCHIVE)  || error("Directory $CSV_ARCHIVE does not exist")
  isdir(JSON_ARCHIVE) || error("Cannot access $JSON_ARCHIVE") 
  @show CSV_ARCHIVE
  @show JSON_ARCHIVE  
end

include("d_str.jl")
include("read.jl")
include("json2csv.jl")
include("df2df4odbimport.jl")
end
