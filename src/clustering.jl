
df = Netatmo.read([DateTime(2019,08,22,03,00), DateTime(2019,08,22,03,10)],latrange=[50,60],lonrange=[0,20])

R = dbscan(collect([df[:lat] df[:lon]]'), 0.05, min_neighbors=5)


scatter(df[R[2].core_indices,:lon], df[R[2].core_indices,:lat],markersize=0.1,legend=false)
for i=2:length(R)
    scatter!(df[R[i].core_indices,:lon], df[R[i].core_indices,:lat],markersize=0.1,legend=false)
end