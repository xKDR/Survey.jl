"""
    jackknifeweights(design::SurveyDesign)

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
```jldoctest
julia> using Survey;

julia> apistrat = load_data("apistrat");

julia> dstrat = SurveyDesign(apistrat; strata=:stype, weights=:pw);

julia> rstrat = jackknifeweights(dstrat)
ReplicateDesign{JackknifeReplicates}:
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

    return ReplicateDesign{JackknifeReplicates}(
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
    variance(x::Symbol, func::Function, design::ReplicateDesign{JackknifeReplicates})

Compute variance of column `x` for the given `func` using the Jackknife method. The formula to compute this variance is the following.

```math
\\hat{V}_{\\text{JK}}(\\hat{\\theta}) = \\sum_{h = 1}^H \\dfrac{n_h - 1}{n_h}\\sum_{j = 1}^{n_h}(\\hat{\\theta}_{(hj)} - \\hat{\\theta})^2
```

Above, ``\\hat{\\theta}`` represents the estimator computed using the original weights, and ``\\hat{\\theta_{(hj)}}`` represents the estimator computed from the replicate weights obtained when PSU ``j`` from cluster ``h`` is removed.

# Examples
```jldoctest; setup = :(using Survey, StatsBase, DataFrames; apistrat = load_data("apistrat"); dstrat = SurveyDesign(apistrat; strata=:stype, weights=:pw); rstrat = jackknifeweights(dstrat);)

julia> mean(df::DataFrame, column, weights) = StatsBase.mean(df[!, column], StatsBase.weights(df[!, weights]));

julia> variance(:api00, mean, rstrat)
1×2 DataFrame
 Row │ estimator  SE
     │ Float64    Float64
─────┼────────────────────
   1 │   662.287  9.53613
```
# Reference
pg 380-382, Section 9.3.2 Jackknife - Sharon Lohr, Sampling Design and Analysis (2010)
"""
function variance(x::Union{Symbol, Vector{Symbol}}, func::Function, design::ReplicateDesign{JackknifeReplicates}, args...; kwargs...)
    
    df = design.data
    stratified_gdf = groupby(df, design.strata)

    # estimator from original weights
    θs = func(design.data, x, design.weights, args...; kwargs...)

    # ensure that θs is a vector
    θs = (θs isa Vector) ? θs : [θs]  

    variance = zeros(length(θs))
    replicate_index = 1

    for subgroup in stratified_gdf
        
        psus_in_stratum = unique(subgroup[!, design.cluster])
        nh = length(psus_in_stratum)
        cluster_variance = zeros(length(θs))

        for psu in psus_in_stratum

            # estimator from replicate weights
            θhjs = func(design.data, x, "replicate_" * string(replicate_index), args...; kwargs...)
            
            # update the cluster variance for each estimator
            for i in 1:length(θs)
                cluster_variance[i] += ((nh - 1)/nh) * (θhjs[i] - θs[i])^2
            end

            replicate_index += 1
        end

        # update the overall variance
        variance .+= cluster_variance
    end

    return DataFrame(estimator = θs, SE = sqrt.(variance))
end