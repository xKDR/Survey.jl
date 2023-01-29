"""
    total(var, design)

Compute the estimated population total for one or more variables within a survey design.

```jldoctest
julia> apiclus1 = load_data("apiclus1");

julia> clus_one_stage = SurveyDesign(apiclus1; clusters = :dnum, weights = :pw) |> bootweights;

julia> total(:api00, clus_one_stage)
1×2 DataFrame
 Row │ total      SE
     │ Float64    Float64
─────┼──────────────────────
   1 │ 3.98999e6  9.01611e5

julia> total([:api00, :enroll], clus_one_stage)
2×3 DataFrame
 Row │ names   total      SE
     │ String  Float64    Float64
─────┼──────────────────────────────
   1 │ api00   3.98999e6  9.01611e5
   2 │ enroll  3.40494e6  9.33396e5
```
"""
function total(x::Symbol, design::ReplicateDesign)
    X = wsum(design.data[!, x], weights(design.data[!,design.weights]))
    Xt = [wsum(design.data[!, x], weights(design.data[! , "replicate_"*string(i)])) for i in 1:design.replicates]
    variance = sum((Xt .- X).^2) / design.replicates
    DataFrame(total = X, SE = sqrt(variance))
end

function total(x::Vector{Symbol}, design::ReplicateDesign)
    df = reduce(vcat, [total(i, design) for i in x])
    insertcols!(df, 1, :names => String.(x))
    return df
end

"""
    total(var, domain, design)

Compute the estimated population total within a domain.

```jldoctest
julia> apiclus1 = load_data("apiclus1");

julia> clus_one_stage = SurveyDesign(apiclus1; clusters = :dnum, weights = :pw) |> bootweights;

julia> total(:api00, :cname, clus_one_stage)
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
function total(x::Symbol, domain::Symbol, design::ReplicateDesign)
    df = bydomain(x, domain, design, wsum)
    rename!(df, :statistic => :total)
end
