"""
    total(var, design)

Estimate the population total of variable.

```jldoctest
julia> apiclus1 = load_data("apiclus1");

julia> dclus1 = SurveyDesign(apiclus1; clusters = :dnum, weights = :pw);

julia> total(:api00, dclus1)
1×1 DataFrame
 Row │ total
     │ Float64
─────┼───────────
   1 │ 3.98999e6
```
"""
function total(x::Symbol, design::SurveyDesign)
    X̂ = wsum(design.data[!, x], weights(design.data[!, design.weights]))
    variance = HartleyRao(x, design, X̂)
    DataFrame(total = X̂, SE = sqrt(variance))
end

"""
Use replicate weights to compute the standard error of the estimated total. 

```jldoctest; setup = :(apiclus1 = load_data("apiclus1"); dclus1 = SurveyDesign(apiclus1; clusters = :dnum, weights = :pw))
julia> bclus1 = dclus1 |> bootweights;

julia> total(:api00, bclus1)
1×2 DataFrame
 Row │ total      SE
     │ Float64    Float64
─────┼──────────────────────
   1 │ 3.98999e6  9.01611e5
```
"""
function total(x::Symbol, design::ReplicateDesign)
    X = wsum(design.data[!, x], weights(design.data[!, design.weights]))
    Xt = [
        wsum(design.data[!, x], weights(design.data[!, "replicate_"*string(i)])) for
        i = 1:design.replicates
    ]
    variance = sum((Xt .- X) .^ 2) / design.replicates
    DataFrame(total = X, SE = sqrt(variance))
end

"""
Estimate the population total of a list of variables.

```jldoctest totallabel; setup = :(apiclus1 = load_data("apiclus1"); dclus1 = SurveyDesign(apiclus1; clusters = :dnum, weights = :pw); bclus1 = dclus1 |> bootweights)
julia> total([:api00, :enroll], dclus1)
2×2 DataFrame
 Row │ names   total
     │ String  Float64
─────┼───────────────────
   1 │ api00   3.98999e6
   2 │ enroll  3.40494e6
``` 

Use replicate weights to compute the standard error of the estimated means. 

```jldoctest totallabel
julia> total([:api00, :enroll], bclus1)
2×3 DataFrame
 Row │ names   total      SE
     │ String  Float64    Float64
─────┼──────────────────────────────
   1 │ api00   3.98999e6  9.01611e5
   2 │ enroll  3.40494e6  9.33396e5 
```
"""
function total(x::Vector{Symbol}, design::AbstractSurveyDesign)
    df = reduce(vcat, [total(i, design) for i in x])
    insertcols!(df, 1, :names => String.(x))
    return df
end

"""
    total(var, domain, design)

Estimate population totals of domains.

```jldoctest totallabel; setup = :(apiclus1 = load_data("apiclus1"); dclus1 = SurveyDesign(apiclus1; clusters = :dnum, weights = :pw); bclus1 = dclus1 |> bootweights)
julia> total(:api00, :cname, dclus1)
11×2 DataFrame
 Row │ cname        total
     │ String15     Float64
─────┼─────────────────────────────
   1 │ Alameda      249080.0
   2 │ Fresno        63903.1
   3 │ Kern          30631.5
   4 │ Los Angeles       3.2862e5
   5 │ Mendocino     84380.6
   6 │ Merced        70300.2
   7 │ Orange            3.84807e5
   8 │ Plumas            2.16147e5
   9 │ San Diego         1.2276e6
  10 │ San Joaquin       6.90276e5
  11 │ Santa Clara       6.44244e5 
```
Use the replicate design to compute standard errors of the estimated totals. 

```jldoctest totallabel
julia> total(:api00, :cname, bclus1)
11×3 DataFrame
 Row │ cname        total           SE
     │ String15     Float64         Float64
─────┼────────────────────────────────────────────
   1 │ Santa Clara       6.44244e5      4.2273e5
   2 │ San Diego         1.2276e6       8.62727e5
   3 │ Merced        70300.2        71336.3
   4 │ Los Angeles       3.2862e5       2.93936e5
   5 │ Orange            3.84807e5      3.88014e5
   6 │ Fresno        63903.1        64781.7
   7 │ Plumas            2.16147e5      2.12089e5
   8 │ Alameda      249080.0            2.49228e5
   9 │ San Joaquin       6.90276e5      6.81604e5
  10 │ Kern          30631.5        30870.3
  11 │ Mendocino     84380.6        80215.9
```
"""
function total(x::Symbol, domain::Symbol, design::AbstractSurveyDesign)
    df = bydomain(x, domain, design, wsum)
    rename!(df, :statistic => :total)
end
