module Netatmo

import DataFrames, CategoricalArrays, CSV, JSON
using Glob, Dates, ProgressMeter

export read
export json2csv

CSV_ARCHIVE="/lustre/storeB/users/roels/netatmo"
JSON_ARCHIVE="/lustre/storeB/project/metproduction/products/netatmo/"

function __init__()
  isdir(CSV_ARCHIVE)  || error("Directory $CSV_ARCHIVE does not exist")
  isdir(JSON_ARCHIVE) || error("Cannot access $JSON_ARCHIVE") 
  println("CSV_ARCHIVE=$CSV_ARCHIVE")
  println("JSON_ARCHIVE=$JSON_ARCHIVE")
end


include("read.jl")
include("json2csv.jl")
end
