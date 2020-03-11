function thin_randomselect(df)

    
    roundmult(val, prec) = round(val / prec) * prec

    # note also introduces new column :time
    latlonprec = 0.2
    df[!,:lonround]  = roundmult.(df[:,:lon], latlonprec)
    df[!,:latround]  = roundmult.(df[:,:lat], latlonprec)
    # df[!,:time] = round.(Dates.unix2datetime.(df[:,:time_utc]), Dates.Hour(3))

    
 
    groups = DataFrames.groupby(df, [:latround, :lonround])

    out_df = DataFrames.DataFrame(id = String[], lat = Float64[], lon=Float64[], alt=Float64[], pressure = Float64[])

    for group in groups
        # better to use some proper distance function here 
        distance =  (group[:,:latround] - group[:,:lat]).^2 + (group[:,:lonround] - group[:,:lon]).^2        
        minindex = findmin(distance)[2]

        id = group[minindex,:id]
        iddf  = group[group[:,:id] .== id,:]

        push!(out_df,iddf[1,:id],[iddf[1,:lat], iddf[1,:lon], iddf[1,:alt], mean(iddf[:,:pressure])])      
    end 

    return out_df
end 



