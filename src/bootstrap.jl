struct Bootstrap 
    replicates
    rng
    function Bootstrap(; replicates = 1000, rng = MersenneTwister(111))
        new(replicates, rng)
    end
end

"""
```jldoctest
julia> using Survey, Random, StatsBase; 

julia> apiclus1 = load_data("apiclus1"); 

julia> dclus1 = SurveyDesign(apiclus1, :dnum, :fpc); 

julia> rng = MersenneTwister(111); 

julia> func = wsum; 

julia> Survey.bootstrap(:api00, dclus1, func; replicates=1000, rng) 
1×2 DataFrame
 Row │ statistic  SE        
     │ Float64    Float64   
─────┼──────────────────────
   1 │ 5.94916e6  1.36593e6

```
"""
function bootstrap(x::Symbol, design::SurveyDesign, func = wsum; replicates = 100, rng = MersenneTwister(1234))
    X = func(design.data[:, x], design.data.weights)
    H = length(unique(design.data[!, design.strata]))
    stratified = groupby(design.data, design.strata)
    Xt = Array{Float64, 1}(undef, replicates)
    for i in 1:replicates
        Xh = []
        Wh = []
        for j in 1:H
            substrata = DataFrame(stratified[j])
            psus = unique(substrata[!, design.cluster])
            if length(psus) == 1
                return DataFrame(statistic = X, SE = 0)
            end
            nh = length(psus)
            gdf = groupby(substrata, design.cluster)
            selected_psus = psus[rand(rng, 1:nh, (nh-1))] # simple random sample of PSUs, with replacement. Select (nh-1) out of nh
            xhij = (reduce(vcat, [gdf[(i,)][!, x] for i in selected_psus]))
            whij = (reduce(vcat, [gdf[(i,)].weights * (nh / (nh - 1)) for i in selected_psus]))
            append!(Xh, xhij)
            append!(Wh, whij)
        end
        Xh = Float64.(Xh)
        Wh = Float64.(Wh)
        Xt[i] = func(Xh, Wh)
        end 
        variance = sum((Xt .- X).^2) / replicates
    return DataFrame(statistic = X, SE = sqrt(variance))
end