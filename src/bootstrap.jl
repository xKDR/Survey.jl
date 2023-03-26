"""
Use bootweights to create replicate weights using Rao-Wu bootstrap. The function accepts a `SurveyDesign` and returns a `ReplicateDesign` which has additional columns for replicate weights. 

```jldoctest
julia> using Random

julia> apiclus1 = load_data("apiclus1");

julia> dclus1 = SurveyDesign(apiclus1; clusters = :dnum, popsize=:fpc);

julia> bootweights(dclus1; replicates=1000, rng=MersenneTwister(111)) # choose a seed for deterministic results
ReplicateDesign:
data: 183×1044 DataFrame
strata: none
cluster: dnum
    [61, 61, 61  …  815]
popsize: [757, 757, 757  …  757]
sampsize: [15, 15, 15  …  15]
weights: [50.4667, 50.4667, 50.4667  …  50.4667]
allprobs: [0.0198, 0.0198, 0.0198  …  0.0198]
replicates: 1000
```
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
    return ReplicateDesign(
        df,
        design.cluster,
        design.popsize,
        design.sampsize,
        design.strata,
        design.weights,
        design.allprobs,
        design.pps,
        replicates,
    )
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
