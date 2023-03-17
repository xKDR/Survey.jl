"""
    Delete-1 Jackknife algorithm for replication weights from sampling weights
    
    Replicate weights are given by:
    wi(hj)  = wi, if observation unit i is not in stratum h
            = 0, if observation unit i is in psu j of stratum h
            = nh(nh −1)wi, if observation unit i is in stratum h but not in psu j.

    ## Reference
    pg 380-382, Section 9.3.2 Jackknife - Sharon Lohr, Sampling Design and Analysis (2010)
"""
function jackknifeweights(design::SurveyDesign)
    sort!(design.data, [design.strata, design.cluster])
    df = design.data

    stratified_gdf = groupby(df, design.strata)
    replicate_index = 0
    for (key, subgroup) in pairs(stratified_gdf)
        stratum = key[design.strata]    # current stratum
        psus_in_stratum = unique(subgroup[!, design.cluster])
        nh = length(psus_in_stratum)

        for psu in psus_in_stratum
            replicate_index += 1
            colname = "replicate_"*string(replicate_index)

            # Initialise replicate_i with original sampling weights
            df[!, colname] = Vector(df[!, design.weights])

            # getting indexes
            same_psu = (df[!, design.strata] .== stratum) .&& (df[!, design.cluster] .== psu)
            different_psu = (df[!, design.strata] .== stratum) .&& (df[!, design.cluster] .!== psu)

            # scaling weights appropriately
            df[same_psu, colname] .*= 0
            df[different_psu, colname] .*= nh/(nh - 1)
        end
    end

    return ReplicateDesign(
        df,
        design.cluster,
        design.popsize,
        design.sampsize,
        design.strata,
        design.weights,
        design.allprobs,
        design.pps,
        "jackknife",
        UInt(replicate_index),
        [Symbol("replicate_"*string(index)) for index in 1:replicate_index]
    )
end

function jackknife_variance(x::Symbol, func::Function, design::ReplicateDesign)
    df = design.data
    # sort!(df, [design.strata, design.cluster])
    stratified_gdf = groupby(df, design.strata)

    # estimator from original weights
    θ = func(df[!, x], df[!, design.weights])

    variance = 0
    replicate_index = 1
    for subgroup in stratified_gdf
        psus_in_stratum = unique(subgroup[!, design.cluster])
        nh = length(psus_in_stratum)
        cluster_variance = 0
        for psu in psus_in_stratum
            # get replicate weights corresponding to current stratum and psu
            rep_weights = design.data[!, "replicate_"*string(replicate_index)]

            # estimator from replicate weights
            θhj = func(design.data[!, x], rep_weights)

            cluster_variance += ((nh - 1)/nh)*(θhj - θ)^2
            replicate_index += 1
        end
        variance += cluster_variance
    end

    return DataFrame(estimator = θ, SE = sqrt(variance))
end

