function thin_togrid(df,distance)

    Rearth = Domains.Rearth
    groups= DataFrames.groupby(df,:id)
    lats = [g[1,:lat] for g in groups]
    lons = [g[1,:lon] for g in groups]

    @info "Create balltree"
    kdtree = NearestNeighbors.BallTree(collect([lons lats]'),Distances.Haversine(Rearth),leafsize=10)

    # maxdist = 20000.
    domain = Domains.Domain("METCOOP25C")
    lonlat = Domains.getgridpoints(domain,gsize=distance)
    out_df = DataFrames.DataFrame(id = String[], lat = Float64[], lon=Float64[], alt=Float64[], pressure = Float64[])


    @info "Loop over lon lat "
    ind, dist = knn(kdtree,collect([getindex.(lonlat,1) getindex.(lonlat,2)]'),1)

    mask = getindex.(dist) .< distance/2.5   # only use Netatmo stations within maxdist/2 of grid point
    ok_indices = getindex.(ind,1)[mask]

    
    for ind in ok_indices 
        s = groups[ind]
        push!(out_df,[s[1,:id],s[1,:lat], s[1,:lon], s[1,:alt], Statistics.mean(s[:,:pressure])])              
    end   
    @assert nrow(out_df) == nrow(unique(out_df,:id))  # make sure all id's are unique
    # scatter(out_df[:,:lon],out_df[:,:lat],legend=false)
    return out_df
end 



