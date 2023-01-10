"""
    total(var, design)

Compute the estimated population total for one or more variables within a survey design.

```jldoctest
julia> apiclus1 = load_data("apiclus1");

julia> clus1 = SurveyDesign(apiclus1; clusters = :dnum, weights = :pw) |> bootweights;

julia> total(:api00, clus1)
1×2 DataFrame
 Row │ total      SE
     │ Float64    Float64
─────┼──────────────────────
   1 │ 3.98999e6  9.22175e5

julia> total([:api00, :enroll], clus1)
2×3 DataFrame
 Row │ names   total      SE
     │ String  Float64    Float64
─────┼──────────────────────────────
   1 │ api00   3.98999e6  9.22175e5
   2 │ enroll  3.40494e6  9.51557e5
```
"""
function total(x::Symbol, design::ReplicateDesign)
    X = wsum(design.data[!, x], weights(design.data.weights))
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

julia> clus1 = SurveyDesign(apiclus1; clusters = :dnum, weights = :pw) |> bootweights;

julia> total(:api00, :cname, clus1)
11×3 DataFrame
 Row │ cname        total           SE
     │ String15     Float64         Any
─────┼────────────────────────────────────────
   1 │ Alameda      249080.0        2.48842e5
   2 │ Fresno        63903.1        64452.2
   3 │ Kern          30631.5        31083.0
   4 │ Los Angeles       3.2862e5   2.93649e5
   5 │ Mendocino     84380.6        83154.4
   6 │ Merced        70300.2        69272.5
   7 │ Orange            3.84807e5  3.90097e5
   8 │ Plumas            2.16147e5  2.17811e5
   9 │ San Diego         1.2276e6   8.78559e5
  10 │ San Joaquin       6.90276e5  6.90685e5
  11 │ Santa Clara       6.44244e5  4.09943e5
```
"""
function total(x::Symbol, domain::Symbol, design::ReplicateDesign)
    df = bydomain(x, domain, design, wsum)
    rename!(df, :statistic => :total)
end