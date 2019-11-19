#usr/bin/env julia

using Netatmo

"""
  Usage:
    ./retrieve_synop DTG DTGEND
"""


DTG= d"$(ARGS[1])"
referencetime=Dates.format(a,"YYYYmmddTHH")

DTGEND=d"$(ARGS[2])"
clientid="de8e45f0-b83c-492f-96a4-96f09de5706d"
baseurl="https://frost.met.no/observations/v0.csv?"


sources=sn18700&referencetime=2010-01-01T12&elements=air_temperature

command=`curl -X GET --user $clientid: $baseurl   `

run(command)
