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
    df = design.data

    # Find number of psus (nh) in each strata, used inside loop
    stratified_gdf = groupby(df, design.strata)
    nh = Dict{String, Int}()
    for (key, subgroup) in pairs(stratified_gdf)
        nh[key[design.strata]] = length(unique(subgroup[!, design.cluster]))
    end

    # iterating over each unique combinations of strata and cluster
    unique_strata_cols_df = unique(select(df, design.strata, design.cluster))
    replicate_index = 1
    for row in eachrow(unique_strata_cols_df)
        stratum = row[design.strata]
        psu = row[design.cluster]
        colname = "replicate_"*string(replicate_index)

        # Initialise replicate_i with original sampling weights
        df[!, colname] = Vector(df[!, design.weights])

        # getting indexes
        same_psu = (df[!, design.strata] .== stratum) .&& (df[!, design.cluster] .== psu)
        different_psu = (df[!, design.strata] .== stratum) .&& (df[!, design.cluster] .!== psu)

        # scaling weights appropriately
        df[same_psu, colname] .*= 0
        df[different_psu, colname] .*= nh[stratum]/(nh[stratum] - 1)

        replicate_index += 1
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
        UInt(DataFrames.nrow(unique_strata_cols_df)),
        [Symbol("replicate_"*string(index)) for index in 1:DataFrames.nrow(unique_strata_cols_df)]
    )
end