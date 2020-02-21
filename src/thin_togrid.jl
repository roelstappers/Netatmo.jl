function thin_togrid(df)

    Rearth = 6.371e6
    groups= groupby(df,:id)
    lats = [g[1,:lat] for g in groups]
    lons = [g[1,:lon] for g in groups]

    kdtree = BallTree(collect([lons lats]'),Haversine(Rearth); leafsize = 10)


    out_df = DataFrames.DataFrame(id = String[], lat = Float64[], lon=Float64[], alt=Float64[], pressure = Float64[])
    
    latgrid = 50:0.2:85
    longrid = 0:0.2:35
    ind = 0 
    for lat in latgrid 
        for lon in longrid            
            ind, dist = knn(kdtree,[lon, lat],1)
            if dist[1] < 20000.0   # accept points up to 20 km from grid point 
                s = groups[ind[1]]
                push!(out_df,[s[1,:id],s[1,:lat], s[1,:lon], s[1,:alt], mean(s[:,:pressure])])      
            end
        end
    end

        



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



