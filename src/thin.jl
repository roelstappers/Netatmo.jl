function thin(df)
    # note also introduces new column :time
    df[:,:lon]  = round.(df[!,:lon], digits = 1)
    df[:,:lat]  = round.(df[!,:lat], digits = 1)
    df[:,:time] = round.(Dates.unix2datetime.(df[!,:time_utc]), Dates.Hour(3))

  # group dataframe by lat lon time and compute mean pressure and altitude
    dfmean  = DataFrames.by(df, [:time, :lat, :lon], mean_pressure = :pressure => mean, mean_alt = :alt =>mean)
end 



