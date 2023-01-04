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
        for h in 1:H
            substrata = DataFrame(stratified[h])
            psus = unique(substrata[!, design.cluster])
            # @show psus
            if length(psus) <= 1
                return DataFrame(statistic = X, SE = 0) # bug! 
            end
            nh = length(psus)
            randinds = rand(rng, 1:(nh), (nh-1)) # Main bootstrap algo. Draw nh-1 out of nh, with replacement.  
            rh = [(count(==(i), randinds)) for i in 1:nh] # main bootstrap algo. 
            gdf = groupby(substrata, design.cluster)
            # @show keys(gdf)
            for i in 1:nh
                gdf[i].whij = repeat([rh[i]], nrow(gdf[i])) .* gdf[i].weights .* (nh / (nh - 1))
            end            
            stratified[h].whij = transform(gdf).whij
            
        end
        return transform(stratified, :whij)
    end
    df = replicate(stratified, H)
    rename!(df,:whij => :replicate_1)
    df.replicate_1 = disallowmissing(df.replicate_1)
    for i in 2:(replicates)
        df[!, "replicate_"*string(i)] = disallowmissing(replicate(stratified, H).whij)
    end 
    return ReplicateDesign(df, design.cluster, design.popsize, design.sampsize, design.strata, design.pps, replicates) 
end

function bootstrap(x::Symbol, design::SurveyDesign, func = wsum; replicates = 100, rng = MersenneTwister(1234))
    gdf = groupby(design.data, design.cluster)
    psus = unique(design.data[!, design.cluster])
    nh = length(psus)
    X = func(design.data[:, x], design.data.weights)
    Xt = Array{Float64, 1}(undef, replicates)
    for i in 1:replicates
        selected_psus = psus[rand(rng, 1:nh, (nh-1))] # simple random sample of PSUs, with replacement. Select (nh-1) out of nh
        xhij = (reduce(vcat, [gdf[(i,)][!, x] for i in selected_psus]))
        whij = (reduce(vcat, [gdf[(i,)].weights * (nh / (nh - 1)) for i in selected_psus]))
        Xt[i] = func(xhij, whij)
    end 
    @show Xt
    variance = sum((Xt .- X).^2) / replicates
    return DataFrame(statistic = X, SE = sqrt(variance))
end