"""
```jldoctest
julia> using Random

julia> apiclus1 = load_data("apiclus1");


julia> clus_one_stage = SurveyDesign(apiclus1; clusters = :dnum, popsize=:fpc);


julia> bootweights(clus_one_stage; replicates=1000, rng=MersenneTwister(111)) # choose a seed for deterministic results
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
function bootweights(design::SurveyDesign; replicates=4000, rng=MersenneTwister(1234))
    stratified = groupby(design.data, design.strata)
    H = length(keys(stratified))
    substrata_dfs = []
    for h in 1:H
        substrata = DataFrame(stratified[h])
        cluster_sorted = sort(substrata, design.cluster)
        psus = unique(cluster_sorted[!, design.cluster])
        npsus = [(count(==(i), cluster_sorted[!, design.cluster])) for i in psus]
        nh = length(psus)
        randinds = rand(rng, 1:(nh), replicates, (nh-1))
        for replicate in 1:replicates
            rh = zeros(Int, nh)
            for i in randinds[replicate, :]
                rh[i] += 1
            end            
            cluster_sorted[!, "replicate_" * string(replicate)] = vcat([fill(rh[i] * (nh / (nh-1)), npsus[i]) for i in 1:length(rh)]...) .* cluster_sorted[!, design.weights] 
        end   
        push!(substrata_dfs, cluster_sorted)
    end
    df = vcat(substrata_dfs...)
    return ReplicateDesign(df, design.cluster, design.popsize, design.sampsize, design.strata, design.weights, design.allprobs, design.pps, replicates) 
end
