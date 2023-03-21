"""
```julia
jackknifeweights(design::SurveyDesign)
```
Delete-1 Jackknife algorithm for replication weights from sampling weights. The replicate weights are calculated using the following formula.

```math
w_{i(hj)} =
\\begin{cases}
    w_i\\quad\\quad &\\text{if observation unit }i\\text{ is not in stratum }h\\\\
    0\\quad\\quad &\\text{if observation unit }i\\text{ is in psu }j\\text{of stratum }h\\\\
    \\dfrac{n_h}{n_h - 1}w_i \\quad\\quad &\\text{if observation unit }i\\text{ is in stratum }h\\text{ but not in psu }j\\\\
\\end{cases}
```
In the above formula, ``w_i`` represent the original weights, ``w_{i(hj)}`` represent the replicate weights when the ``j``th PSU from cluster ``h`` is removed, and ``n_h`` represents the number of unique PSUs within cluster ``h``. Replicate weights are added as columns to `design.data`, and these columns have names of the form `replicate_i`, where `i` ranges from 1 to the number of replicate weight columns.

# Examples
```jldoctest setup = :(using Survey)
julia> apistrat = load_data("apistrat");

julia> dstrat = SurveyDesign(apistrat; strata=:stype, weights=:pw);

julia> rstrat = jackknifeweights(dstrat)
ReplicateDesign:
data: 200×244 DataFrame
strata: stype
    [E, E, E  …  M]
cluster: none
popsize: [4420.9999, 4420.9999, 4420.9999  …  1018.0]
sampsize: [100, 100, 100  …  50]
weights: [44.21, 44.21, 44.21  …  20.36]
allprobs: [0.0226, 0.0226, 0.0226  …  0.0491]
type: jackknife
replicates: 200

```

# Reference
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

"""
```julia
jackknife_variance(x::Symbol, func::Function, design::ReplicateDesign)
```

Compute variance for the given `func` using the Jackknife method. The formula to compute this variance is the following.

```math
\\hat{V}_{\\text{JK}}(\\hat{\\theta}) = \\sum_{h = 1}^H \\dfrac{n_h - 1}{n_h}\\sum_{j = 1}^{n_h}(\\hat{\\theta}_{(hj)} - \\hat{\\theta})^2
```
"""
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

