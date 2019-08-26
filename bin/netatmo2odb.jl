#!/usr/bin/env julia

# this will convert a netatmo csv file to 
# 1. csv with columns names that odb import understand
# 2. Uses odb import to create an ODB2 database
# 3. Uses odb2_to_odb1.x to convert ODB2 to an ODB1 database  

using Netatmo, CSV, ODB

csvfile="$(Netatmo.CSV_ARCHIVE)/2019/05/01/20190501T094501Z.csv"
# csvfile=ARGS[1]

filename, ext = splitext(basename(csvfile))
outcsvfilename = "$(filename)_temp.csv"
odbname="netatmo"
npools=1

npools==1 || error("Check with Eoin. Not sure what to do for npools>1")

df = CSV.read(csvfile )
df2 = df2df4odbimport(df)


CSV.write(outcsvfilename,df2)   

# note . is the working directory for the Cmd object which is set later setenv
create_ioassign=`create_ioassign -l $odbname -d . -n $npools`
create_ioassign=


`odb import $outcsvfilename $odbname.1.odb`

odb2_to_odb1.x -i syn -t groupid\=17.tables 
setenv()

ENVexport ODB_API_TEST_DATA_PATH=/home/roels/.julia/dev/ODB/deps/build/odb_api_bundle-0.18.1-Source/odb-tools/src/tests/
export ODB_ROOT=../../../../../install/odb_api_bundle-0.18.1-Source/
export ODB_SYSPATH=/home/roels/.julia/dev/ODB/deps/install/odb_api_bundle-0.18.1-Source/include
export ODB_BEBINPATH=/home/roels/.julia/dev/ODB/deps/install/odb_api_bundle-0.18.1-Source/bin
export ODB_FEBINPATH=/home/roels/.julia/dev/ODB/deps/install/odb_api_bundle-0.18.1-Source/bin
export ODB_BINPATH=/home/roels/.julia/dev/ODB/deps/install/odb_api_bundle-0.18.1-Source/bin




