struct Bootstrap 
    replicates
    rng
    function Bootstrap(; replicates = 100, rng = MersenneTwister(111))
        new(replicates, rng)
    end
end

"""
```jldoctest
julia> using Survey, Random, StatsBase; 

julia> apiclus1 = load_data("apiclus1"); 

julia> dclus1 = OneStageClusterSample(apiclus1, :dnum, :fpc); 

julia> rng = MersenneTwister(111); 

julia> func = wsum; 

julia> bootstrap(:api00, dclus1, func; replicates=1000, rng) 
1×2 DataFrame
 Row │ statistic  SE        
     │ Float64    Float64   
─────┼──────────────────────
   1 │ 5.94916e6  1.36593e6

```
"""
function bootstrap(x::Symbol, design::OneStageClusterSample, func = wsum; replicates = 100, rng = MersenneTwister(1234))
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
    variance = sum((Xt .- X).^2) / replicates
    return DataFrame(statistic = X, SE = sqrt(variance))
end
