#!/usr/bin/env julia

using Netatmo, Dates

dtgstart = Dates.Date(2019,08,01)
dtgend   = Dates.Date(2019,08,31)  

json2csv.(dtgstart:Dates.Day(1):dtgend)