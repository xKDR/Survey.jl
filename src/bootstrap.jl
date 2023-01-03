"""
```jldoctest
julia> using Survey, Random;

julia> apiclus1 = load_data("apiclus1"); 

julia> dclus1 = SurveyDesign(apiclus1; clusters = :dnum); 

julia> rng = MersenneTwister(111); 

julia> Survey.bootweights(dclus1; replicates=1000, rng) 
Survey.ReplicateDesign:
data: 183x1046 DataFrame
cluster: dnum
design.data[!,design.cluster]: 637, 637, 637, ..., 448
popsize: popsize
design.data[!,design.popsize]: 183, 183, 183, ..., 183
sampsize: sampsize
design.data[!,design.sampsize]: 15, 15, 15, ..., 15
design.data[!,:probs]: 1.0, 1.0, 1.0, ..., 1.0
design.data[!,:allprobs]: 1.0, 1.0, 1.0, ..., 1.0
replicates: 1000
```
"""
function bootweights(design::SurveyDesign; replicates = 4000, rng = MersenneTwister(1234))
    H = length(unique(design.data[!, design.strata]))
    stratified = groupby(design.data, design.strata)
    function replicate(stratified, H)
        for j in 1:H
            substrata = DataFrame(stratified[j])
            psus = unique(substrata[!, design.cluster])
            if length(psus) == 1
                return DataFrame(statistic = X, SE = 0)
            end
            nh = length(psus)
            randinds = rand(rng, 1:(nh), (nh-1)) # Main bootstrap algo. Draw nh-1 out of nh, with replacement.  
            rh = [(count(==(i), randinds)) for i in 1:nh] # main bootstrap algo. 
            gdf = groupby(substrata, design.cluster)
            for i in 1:nh
                gdf[i].rh = repeat([rh[i]], nrow(gdf[i]))
            end
            stratified[j].rh = DataFrame(gdf).rh
        end
        return DataFrame(stratified)
    end
    df = replicate(stratified, H)
    rename!(df,:rh => :replicate_1)
    for i in 2:(replicates)
        df[!, "replicate_"*string(i)] = Float64.(replicate(stratified, H).rh)
    end 
    return ReplicateDesign(df, design.cluster, design.popsize, design.sampsize, design.strata, design.pps, replicates) 
end