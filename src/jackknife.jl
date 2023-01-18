""" Structure for jackknife"""
struct Jackknife end

"""Function that calculates jackknife"""
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

function jackknifeweights(design::SurveyDesign )
    H = length(unique(design.data[!, design.strata]))
    stratified = groupby(design.data, design.strata)
    for j in 1:H
        substrata = DataFrame(stratified[j])
        psus = unique(substrata[!, design.cluster])
        if length(psus) == 1
            return DataFrame(statistic = X, SE = 0)
        end
        newv=[]
        nh = length(psus)
        gdf = groupby(substrata, design.cluster)
        replicates = [filter(n -> n != i, 1:nh) for i in 1:nh]
        clusterweights = []
        for replicate in replicates
            push!(clusterweights ,[(count(==(i), replicate)) for i in 1:nh].*(nh/(nh-1)) )# main jackknife algo. 
        end
        for j in 1:nh 
            clusterweight = clusterweights[j]
            for i in 1:nh 
                gdf[i][!,"replicate_"*string(j)] = clusterweight[i].*DataFrame(gdf[i]).weights
            end
        end
        stratified[j].replicate_1 = DataFrame(gdf).replicate_1
    end
    DataFrame(stratified)
    return ReplicateDesign(DataFrame(stratified), design.cluster, design.popsize, design.sampsize, design.strata, design.pps, replicates) 
end