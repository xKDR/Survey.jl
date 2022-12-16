function jkknife(variable:: Symbol, design::OneStageClusterSample ,func:: Function;  params =[])
    statistic = func(design.data[!,variable],params...)
    nh = length(unique(design.data[!,design.cluster]))
    newv = []
    gdf = groupby(design.data, design.cluster)
    replicates = [filter(n -> n != i, 1:nh) for i in 1:nh] 
    for i in replicates
        push!(newv,func(DataFrame(gdf[i])[!,variable]))
    end
    c = 0
    for i in 1:nh
        c = c+(newv[i]-statistic)^2
    end
    var = c*(nh-1)/nh
    return DataFrame(Statistic = statistic, SE = sqrt(var))
end