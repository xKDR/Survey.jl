"""
Use bootweights to creaye replicate weights using Rao-Wu bootstrap. The function accepts a `SurveyDesign` and returns a `ReplicateDesign` which has additional columns for replicate weights. 

```jldoctest
julia> using Random

julia> dclus1 = SurveyDesign(apiclus1; clusters = :dnum, popsize=:fpc);
```
"""
function jknweights(design::SurveyDesign; replicates = 10, rng = MersenneTwister(1234))
    stratified = groupby(design.data, design.strata)
    H = length(keys(stratified))
    substrata_dfs = DataFrame[]
    for h = 1:H
        substrata = DataFrame(stratified[h])
        cluster_sorted = sort(substrata, design.cluster)
        psus = unique(cluster_sorted[!, design.cluster])
        npsus = [(count(==(i), cluster_sorted[!, design.cluster])) for i in psus]
        nh = length(psus)
        cluster_weights = cluster_sorted[!, design.weights]
        for replicate = 1:replicates
            randinds = rand(rng, 1:(nh), (nh - 1))
            cluster_sorted[!, "replicate_"*string(replicate)] =
                vcat(
                    [
                        fill((nh - count(==(i), randinds)) * ((nh - 1) / nh), npsus[i]) for
                        i = 1:nh
                    ]...,
                ) .* cluster_weights
        end
        push!(substrata_dfs, cluster_sorted)
    end
    df = vcat(substrata_dfs...)
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
