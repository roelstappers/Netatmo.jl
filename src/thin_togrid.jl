function thin_togrid(df)

    Rearth = 6.371e6
    groups= groupby(df,:id)
    lats = [g[1,:lat] for g in groups]
    lons = [g[1,:lon] for g in groups]

    kdtree = BallTree(collect([lons lats]'),Haversine(Rearth); leafsize = 10)

    maxdist = 20000.
    latlons = getgrid(maxdist)
    out_df = DataFrames.DataFrame(id = String[], lat = Float64[], lon=Float64[], alt=Float64[], pressure = Float64[])
    
    #latgrid = 50:0.2:85
    #longrid = 0:0.2:35
    # ind = 0 
    for lat in getindex.(latlons,2)
        # maximum allowed distance to grid box (latitude dependent)
      #   maxdist = haversine([0, lat],[0.2, lat],Rearth)/2 
        for lon in getindex.(latlons,1)
            ind, dist = knn(kdtree,[lon, lat],1)
            if dist[1] < maxdist
                s = groups[ind[1]]
                push!(out_df,[s[1,:id],s[1,:lat], s[1,:lon], s[1,:alt], mean(s[:,:pressure])])      
            end
        end
    end   
    @assert nrow(out_df) == nrow(unique(out_df,:id))  # make sure all id's are unique

    return out_df
end 



