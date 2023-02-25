"""
    Delete 1 jackknife with no/single stratum
    
    ## Reference
    pg 380-382, Section 9.3.2 Jackknife - Sharon Lohr, Sampling Design and Analysis (2010)
"""
function jk1weights(design::SurveyDesign)
    cluster_sorted = sort(design.data, design.cluster) # Does jk need sorting?
    psus = unique(cluster_sorted[!, design.cluster])
    nh = length(psus)
    npsus = [(count(==(i), cluster_sorted[!, design.cluster])) for i in psus]       
    replicates = [filter(n -> n != i, 1:nh) for i in 1:nh]
    cluster_weights = cluster_sorted[!, design.weights]
    for (i,replicate) in enumerate(replicates)
        cluster_sorted[!, "replicate_"*string(i)] = vcat(
            [   fill((count(==(i), replicate)) .* (nh / (nh - 1)), npsus[i]) for i = 1:nh
            ]...,
        ) .* cluster_weights
    end
    return cluster_sorted
end

"""
    WIP: Delete-1 jackknife algorithm for replicate weights columns

    ## Reference
    pg 380-382, Section 9.3.2 Jackknife - Sharon Lohr, Sampling Design and Analysis (2010)
"""
function jackknifeweights(design::SurveyDesign)
    stratified = groupby(design.data, design.strata)
    H = length(keys(stratified))
    @show H
    substrata_dfs = DataFrame[]
    for h in 1:H
        @show h
        substrata = DataFrame(stratified[h])
        cluster_sorted = sort(substrata, design.cluster) # Does jk need sorting?
        psus = unique(cluster_sorted[!, design.cluster])
        # cluster_weights = substrata[!, design.weights]
        # gdf = groupby(substrata, design.cluster)
        # psus = unique(substrata[!, design.cluster])
        nh = length(psus)
        npsus = [(count(==(i), cluster_sorted[!, design.cluster])) for i in psus]       
        replicates = [filter(n -> n != i, 1:nh) for i in 1:nh]
        @show nh, psus, npsus
        # @show replicates
        cluster_weights = cluster_sorted[!, design.weights]
        @show size(cluster_weights)
        for (i,replicate) in enumerate(replicates)
            tmp = vcat(
                    [   fill((count(==(i), replicate)) .* (nh / (nh - 1)), npsus[i]) for i = 1:nh
                    ]...,
                ) .* cluster_weights
            @show tmp
            cluster_sorted[!, "replicate_"*string(i)] = tmp
            
        end
        push!(substrata_dfs, cluster_sorted)
        return vcat(substrata_dfs...)
    end
end
        # push!(cluster_weights, [(count(==(i), replicate)) for i in 1:nh].*(nh/(nh-1)) )# main jackknife algo. 
        # for j in 1:nh 
        #     clusterweight = clusterweights[j]
        #     for i in 1:nh 
        #         gdf[i][!,"replicate_"*string(j)] = clusterweight[i].*DataFrame(gdf[i]).weights
        #     end
        # end
        # stratified[h].replicate_1 = DataFrame(gdf).replicate_1
    
    # df = vcat(substrata_dfs...)
    # return ReplicateDesign(
    #     df,
    #     design.cluster,
    #     design.popsize,
    #     design.sampsize,
    #     design.strata,
    #     design.weights,
    #     design.allprobs,
    #     design.pps,
    #     replicates,
    # )
