"""
Use bootweights to create replicate weights using Rao-Wu bootstrap. The function accepts a `SurveyDesign` and returns a `ReplicateDesign{BootstrapReplicates}` which has additional columns for replicate weights.  

The replicate weight for replicate ``r`` is computed using the formula ``w_{i}(r) = w_i \\times \\frac{n_h}{n_h - 1} m_{hj}(r)`` for observation ``i`` in psu ``j`` of stratum ``h``. 

In the formula above, ``w_i`` is the original weight for observation ``i``, ``n_h`` is the number of psus in stratum ``h``, and ``m_{hj}(r)`` is the number of psus in stratum ``h`` that are selected in replicate ``r``.
    
```jldoctest
julia> using Random

julia> apiclus1 = load_data("apiclus1");

julia> dclus1 = SurveyDesign(apiclus1; clusters = :dnum, popsize=:fpc);

julia> bootweights(dclus1; replicates=1000, rng=MersenneTwister(111)) # choose a seed for deterministic results
ReplicateDesign{BootstrapReplicates}:
data: 183×1044 DataFrame
strata: none
cluster: dnum
    [61, 61, 61  …  815]
popsize: [757, 757, 757  …  757]
sampsize: [15, 15, 15  …  15]
weights: [50.4667, 50.4667, 50.4667  …  50.4667]
allprobs: [0.0198, 0.0198, 0.0198  …  0.0198]
type: bootstrap
replicates: 1000

```

# Reference
pg 384-385, Section 12.1.3 Two-Phase Sampling for Stratification - Sharon Lohr, Sampling Design and Analysis (2010)
"""
function bootweights(design::SurveyDesign; replicates = 4000, rng = MersenneTwister(1234))
    stratified = groupby(design.data, design.strata)
    H = length(keys(stratified))
    substrata_dfs = Vector{DataFrame}(undef, H)
    for h = 1:H
        substrata = DataFrame(stratified[h])
        cluster_sorted = sort(substrata, design.cluster)
        cluster_sorted_designcluster = cluster_sorted[!, design.cluster]
        cluster_weights = cluster_sorted[!, design.weights]
        # Perform the inner loop in a type-stable function to improve runtime.
        _bootweights_cluster_sorted!(cluster_sorted, cluster_weights,
            cluster_sorted_designcluster, replicates, rng)
        substrata_dfs[h] = cluster_sorted
    end
    df = reduce(vcat, substrata_dfs)
    return ReplicateDesign{BootstrapReplicates}(
        df,
        design.cluster,
        design.popsize,
        design.sampsize,
        design.strata,
        design.weights,
        design.allprobs,
        design.pps,
        "bootstrap",
        UInt(replicates),
        [Symbol("replicate_"*string(replicate)) for replicate in 1:replicates],
    )
end

"""
    variance(x::Symbol, func::Function, design::ReplicateDesign{BootstrapReplicates})


Use replicate weights to compute the standard error of the estimated mean using the bootstrap method. The variance is calculated using the formula

```math
\\hat{V}(\\hat{\\theta}) = \\dfrac{1}{R}\\sum_{i = 1}^R(\\theta_i - \\hat{\\theta})^2
```

where above ``R`` is the number of replicate weights, ``\\theta_i`` is the estimator computed using the ``i``th set of replicate weights, and ``\\hat{\\theta}`` is the estimator computed using the original weights.

```jldoctest
julia> using Survey, StatsBase;

julia> apiclus1 = load_data("apiclus1");

julia> dclus1 = SurveyDesign(apiclus1; clusters = :dnum, weights = :pw);

julia> bclus1 = dclus1 |> bootweights;

julia> weightedmean(x, y) = mean(x, weights(y));

julia> variance(:api00, weightedmean, bclus1)
1×2 DataFrame
 Row │ estimator  SE
     │ Float64    Float64
─────┼────────────────────
   1 │   644.169  23.4107

```
"""
function variance(x::Symbol, func::Function, design::ReplicateDesign{BootstrapReplicates})
    θ̂ = func(design.data[!, x], design.data[!, design.weights])
    θ̂t = [
        func(design.data[!, x], design.data[!, "replicate_"*string(i)]) for
        i = 1:design.replicates
    ]
    variance = sum((θ̂t .- θ̂) .^ 2) / design.replicates
    return DataFrame(estimator = θ̂, SE = sqrt(variance))
end

function _bootweights_cluster_sorted!(cluster_sorted,
        cluster_weights, cluster_sorted_designcluster, replicates, rng)

    psus = unique(cluster_sorted_designcluster)
    npsus = [count(==(i), cluster_sorted_designcluster) for i in psus]
    nh = length(psus)
    for replicate = 1:replicates
        randinds = rand(rng, 1:(nh), (nh - 1))
        cluster_sorted[!, "replicate_"*string(replicate)] =
            reduce(vcat,
                [
                    fill((count(==(i), randinds)) * (nh / (nh - 1)), npsus[i]) for
                    i = 1:nh
                ]
            ) .* cluster_weights
    end
    cluster_sorted
end
