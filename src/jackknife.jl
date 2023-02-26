"""
    Delete 1 jackknife with  for unstratified designs.
    
    Replicate weights are given by:
    wi(hj)  = 0, if observation unit i is in psu j of stratum h
            = nh(nh −1)wi, if observation unit i is in stratum h but not in psu j.
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
    return ReplicateDesign(
        cluster_sorted,
        design.cluster,
        design.popsize,
        design.sampsize,
        design.strata,
        design.weights,
        design.allprobs,
        design.pps,
        length(replicates),
    )
end

"""
    Jackknife estimator

    Uses jackknife replicate weights to calculate variance of estimator θ̂
"""
function JackknifeEstimator(θ̂::Float64,design::ReplicateDesign)
    gdf = groupby(design.data,design.strata)
    # @show keys(gdf)
    calc_df = combine(x -> length(unique(x[!,design.cluster])), gdf)
    calc_df[!,:multiplier] = (calc_df[!,:x1] .- 1 ) ./ calc_df[!,:x1]
    # for each_gdf in gdf
    #     @show nrow(each_gdf)
    # end
    return calc_df
end

"""
    WIP: Delete-1 jackknife algorithm for replicate weights columns
    
    Replicate weights are given by:
    wi(hj)  = wi, if observation unit i is not in stratum h
            = 0, if observation unit i is in psu j of stratum h
            = nh(nh −1)wi, if observation unit i is in stratum h but not in psu j.

    ## Reference
    pg 380-382, Section 9.3.2 Jackknife - Sharon Lohr, Sampling Design and Analysis (2010)
"""
function jackknifeweights(design::SurveyDesign)
    df = design.data
    ## Find number of psus (nh) in each strata, used inside loop
    stratified = groupby(df, design.strata)
    nh_df = combine(x -> length(unique(x[!,design.cluster])), gdf)
    
    # Iterate over each combination of strata X cluster
    unique_strata_cols_df = unique(select(df, design.strata, design.cluster))
    counter = 1
    for (strata,psu) in zip(unique_strata_cols_df[!,1],unique_strata_cols_df[!,2])
        colname = "replicate_"*string(counter)
        @show colname, strata, psu
        ###### three mutually exclusive cases based on strata and psu

        ### if observation unit i is not in stratum h
        not_in_strata = df[df[!,design.strata] .!= strata,:] |> nrow
        # Set replicate weights at these indices to: wi  
        
        ### if observation unit i is in psu j of stratum h
        in_strata_psu = df[(df[!,design.strata] .== strata) .&& (df[!,design.cluster] .== psu),:]
        # Set replicate weights at these indices to: 0 
        
        ### if observation unit i is in stratum h but not in psu j.
        in_strata_not_psu = df[(df[!,design.strata] .== strata) .&& (df[!,design.cluster] .!= psu),:]
        # Set replicate weights at these indices to: (nh-1)/nh
        counter += 1
    end
    return
end

    # @show unique_strata_cols_df
    # stratas = unique(df[!,design.strata])
    # psus = unique(df[!,design.cluster])
        # for i in 1:I
            
        #     if design.data[i,design.weights]
        #     design.data[i,colname] =  
        # end
# sort!(design.data, (design.strata,design.cluster))
    # stratified = groupby(design.data, design.strata)
    # H = length(keys(stratified))
    # @show H
    # calc_df = combine(x -> length(unique(x[!,design.cluster])), gdf).x1
    # substrata_dfs = DataFrame[]
    # for h in 1:H
    #     @show h
    #     substrata = DataFrame(stratified[h])
    #     cluster_sorted = sort(substrata, design.cluster) # Does jk need sorting?
    #     psus = unique(cluster_sorted[!, design.cluster])
    #     # cluster_weights = substrata[!, design.weights]
    #     # gdf = groupby(substrata, design.cluster)
    #     # psus = unique(substrata[!, design.cluster])
    #     nh = length(psus)
    #     npsus = [(count(==(i), cluster_sorted[!, design.cluster])) for i in psus]       
    #     replicates = [filter(n -> n != i, 1:nh) for i in 1:nh]
    #     @show nh, psus, npsus
    #     # @show replicates
    #     cluster_weights = cluster_sorted[!, design.weights]
    #     @show size(cluster_weights)
    #     for (i,replicate) in enumerate(replicates)
    #         tmp = vcat(
    #                 [   fill((count(==(i), replicate)) .* (nh / (nh - 1)), npsus[i]) for i = 1:nh
    #                 ]...,
    #             ) .* cluster_weights
    #         @show tmp
    #         cluster_sorted[!, "replicate_"*string(i)] = tmp
            
    #     end
    #     push!(substrata_dfs, cluster_sorted)
    #     return vcat(substrata_dfs...)
    # end

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
