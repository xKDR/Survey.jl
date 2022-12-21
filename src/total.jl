"""
    total(x, design)

Estimate the population total for the variable specified by `x`.

For OneStageClusterSample, formula adapted from Sarndal pg129, section 4.2.2 Simple Random Cluster Sampling

```jldoctest
julia> using Survey;

julia> apisrs = load_data("apisrs");

julia> srs = SimpleRandomSample(apisrs; popsize=:fpc);

julia> total(:enroll, srs)
1×2 DataFrame
 Row │ total      SE 
     │ Float64    Float64  
─────┼─────────────────────
   1 │ 3.62107e6  1.6952e5

julia> strat = load_data("apistrat");

julia> dstrat = StratifiedSample(strat, :stype; popsize=:fpc);

julia> total(:api00, dstrat)
1×2 DataFrame
 Row │ total      SE      
     │ Float64    Float64 
─────┼────────────────────
   1 │ 4.10221e6  58279.0

julia> total([:api00, :enroll], dstrat)
2×3 DataFrame
 Row │ names   total      SE            
     │ String  Float64    Float64       
─────┼──────────────────────────────────
   1 │ api00   4.10221e6  58279.0
   2 │ enroll  3.68718e6      1.14642e5
```
"""
function total(x::Symbol, design::SimpleRandomSample)
    function se(x::Symbol, design::SimpleRandomSample)
        function variance(x::Symbol, design::SimpleRandomSample)
            return design.popsize^2 * design.fpc * var(design.data[!, x]) / design.sampsize
        end
        return sqrt(variance(x, design))
    end
    if isa(design.data[!, x], CategoricalArray)
        gdf = groupby(design.data, x)
        p = combine(gdf, nrow => :count)
        p.total = design.popsize .* p.count ./ sum(p.count)
        p.proportion = p.total ./ design.popsize
        p = select!(p, Not(:count)) # count column is not necessary for `total`
        p.var = design.popsize^2 .* design.fpc .* p.proportion .*
                (1 .- p.proportion) ./ (design.sampsize - 1) # N^2 .* variance of proportion
        p.SE = sqrt.(p.var)
        return select(p, Not([:proportion, :var]))
    end
    m = mean(x,design)
    total = design.popsize * m.mean[1]
    return DataFrame(total=total, SE=se(x, design))
end

function total(x::Symbol, design::StratifiedSample)
    # TODO: check if statement
    if x == design.strata
        gdf = groupby(design.data, x)
        return combine(gdf, :weights => sum => :Nₕ)
    end
    gdf = groupby(design.data, design.strata)
    grand_total = sum(combine(gdf, [x, :weights] => ((a, b) -> wsum(a, b)) => :total).total)
    # variance estimation using closed-form formula
    Nₕ = combine(gdf, :weights => sum => :Nₕ).Nₕ
    nₕ = combine(gdf, nrow => :nₕ).nₕ
    fₕ = nₕ ./ Nₕ

    s²ₕ = combine(gdf, x => var => :s²h).s²h
    # the only difference between total and mean variance is the Nₕ instead of Wₕ
    V̂Ȳ̂ = sum((Nₕ .^ 2) .* (1 .- fₕ) .* s²ₕ ./ nₕ)
    SE = sqrt(V̂Ȳ̂)
    return DataFrame(total=grand_total, SE=SE)
end

function total(x::Vector{Symbol}, design::AbstractSurveyDesign)
    df = reduce(vcat, [total(i, design) for i in x])
    insertcols!(df, 1, :names => String.(x))
    return df
end

function total(x::Symbol, design::OneStageClusterSample)
    gdf = groupby(design.data, design.cluster)
    ŷₜ = combine(gdf, x => sum => :sum).sum
    Nₜ = first(design.data[!,design.popsize])
    Ȳ = Nₜ * mean(ŷₜ)
    nₜ = first(design.data[!,design.sampsize])
    s²ₜ = var(ŷₜ)
    VȲ = Nₜ^2 * (1 - nₜ/Nₜ) * s²ₜ / nₜ
    return DataFrame(total = Ȳ, SE = sqrt(VȲ))
end

"""
    total(x, by, design)

Estimate the subpopulation total of a variable `x`.

```jldoctest
julia> using  Survey;

julia> apisrs = load_data("apisrs");

julia> srs = SimpleRandomSample(apisrs;popsize=:fpc);

julia> total(:api00, :cname, srs) |> first
DataFrameRow
 Row │ cname     total      SE     
     │ String15  Float64    Float64 
─────┼──────────────────────────────
   1 │ Kern      1.77644e5  55600.8

```
"""
function total(x::Symbol, by::Symbol, design::SimpleRandomSample)
    function domain_total(x::AbstractVector, design::SimpleRandomSample, weights)
        function se(x::AbstractVector, design::SimpleRandomSample)
            # vector of length equal to `sampsize` containing `x` and zeros
            z = cat(zeros(design.sampsize - length(x)), x; dims=1)
            variance = design.popsize^2 / design.sampsize * design.fpc * var(z)
            return sqrt(variance)
        end
        total = wsum(x, weights)
        return DataFrame(total=total, SE=se(x, design::SimpleRandomSample))
    end
    gdf = groupby(design.data, by)
    combine(gdf, [x, :weights] => ((a, b) -> domain_total(a, design, b)) => AsTable)
end

"""
```jldoctest
julia> using Survey, Random, StatsBase; 

julia> apiclus1 = load_data("apiclus1"); 

julia> dclus1 = OneStageClusterSample(apiclus1, :dnum, :fpc); 

julia> total(:api00, dclus1, Bootstrap(replicates = 1000, rng = MersenneTwister(111)))
1×2 DataFrame
 Row │ total     SE      
     │ Float64  Float64 
─────┼──────────────────
   1 │ 5.94916e6  1.36593e6
```
"""
function total(x::Symbol, design::OneStageClusterSample, method::Bootstrap)
    df = bootstrap(x, design, wsum; method.replicates, method.rng)
    df = rename(df, :statistic => :total)
end