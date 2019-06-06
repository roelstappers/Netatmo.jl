module Netatmo

import DataFrames, CSV
using Glob, Dates

export read

NETATMO_CSV_ARCHIVE="/home/roels/netatmo"

function __init__()
  isdir(NETATMO_CSV_ARCHIVE) || error("Directory $NETATMO_CSV_ARCHIVE does not exist")
  println("NETATMO_CSV_ARCHIVE=$NETATMO_CSV_ARCHIVE")
end


include("read.jl")
end
