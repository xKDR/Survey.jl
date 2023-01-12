"""
```jldoctest
julia> using Random

julia> apiclus1 = load_data("apiclus1");

julia> clus_one_stage = SurveyDesign(apiclus1; clusters = :dnum);

julia> bootweights(clus_one_stage; replicates=1000, rng=MersenneTwister(111)) # choose a seed for deterministic results
ReplicateDesign:
data: 183×1046 DataFrame
strata: none
cluster: dnum
    [637, 637, 637  …  448]
popsize: [183, 183, 183  …  183]
sampsize: [15, 15, 15  …  15]
weights: [1, 1, 1  …  1]
probs: [1.0, 1.0, 1.0  …  1.0]
replicates: 1000
```
"""
function bootweights(design::SurveyDesign; replicates=4000, rng=MersenneTwister(1234))
    H = length(unique(design.data[!, design.strata]))
    stratified = groupby(design.data, design.strata)
    function replicate(stratified, H)
        for h in 1:H
            substrata = DataFrame(stratified[h])
            psus = unique(substrata[!, design.cluster])
            if length(psus) <= 1
                stratified[h].whij .= 0 # hasn't been tested yet. 
            end
            nh = length(psus)
            randinds = rand(rng, 1:(nh), (nh-1)) # Main bootstrap algo. Draw nh-1 out of nh, with replacement.  
            rh = [(count(==(i), randinds)) for i in 1:nh] # main bootstrap algo. 
            gdf = groupby(substrata, design.cluster)
            for i in 1:nh
                gdf[i].whij = repeat([rh[i]], nrow(gdf[i])) .* gdf[i].weights .* (nh / (nh - 1))
            end            
            stratified[h].whij = transform(gdf).whij
            
        end
        return transform(stratified, :whij)
    end
    df = replicate(stratified, H)
    rename!(df, :whij => :replicate_1)
    df.replicate_1 = disallowmissing(df.replicate_1)
    for i in 2:(replicates)
        df[!, "replicate_" * string(i)] = disallowmissing(replicate(stratified, H).whij)
    end 
    return ReplicateDesign(df, design.cluster, design.popsize, design.sampsize, design.strata, design.pps, replicates) 
end
