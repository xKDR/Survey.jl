"""
    mean(var, design)

Compute the estimated mean of one or more variables within a survey design.

```jldoctest
julia> apiclus1 = load_data("apiclus1");

julia> clus_one_stage = SurveyDesign(apiclus1; clusters = :dnum, weights = :pw) |> bootweights;

julia> mean(:api00, clus_one_stage)
1×2 DataFrame
 Row │ mean     SE      
     │ Float64  Float64 
─────┼──────────────────
   1 │ 644.169  23.2919

julia> mean([:api00, :enroll], clus_one_stage)
2×3 DataFrame
 Row │ names   mean     SE
     │ String  Float64  Float64
─────┼──────────────────────────
   1 │ api00   644.169  23.2919
   2 │ enroll  549.716  45.3655
```
"""
function mean(x::Symbol, design::ReplicateDesign)
    X = mean(design.data[!, x], weights(design.data[!,design.weights]))
    Xt = [mean(design.data[!, x], weights(design.data[! , "replicate_"*string(i)])) for i in 1:design.replicates]
    variance = sum((Xt .- X).^2) / design.replicates
    DataFrame(mean = X, SE = sqrt(variance))
end

function mean(x::Vector{Symbol}, design::ReplicateDesign)
    df = reduce(vcat, [mean(i, design) for i in x])
    insertcols!(df, 1, :names => String.(x))
    return df
end

"""
    mean(var, domain, design)

Compute the estimated mean within a domain.

```jldoctest
julia> apiclus1 = load_data("apiclus1");

julia> clus_one_stage = SurveyDesign(apiclus1; clusters = :dnum, weights = :pw) |> bootweights;

julia> mean(:api00, :cname, clus_one_stage)
11×3 DataFrame
 Row │ cname        mean     SE
     │ String15     Float64  Any
─────┼───────────────────────────────────
   1 │ Alameda      669.0    1.27388e-13
   2 │ Fresno       472.0    1.13687e-13
   3 │ Kern         452.5    0.0
   4 │ Los Angeles  647.267  47.4938
   5 │ Mendocino    623.25   1.0931e-13
   6 │ Merced       519.25   4.57038e-15
   7 │ Orange       710.563  2.19684e-13
   8 │ Plumas       709.556  1.27773e-13
   9 │ San Diego    659.436  2.63446
  10 │ San Joaquin  551.189  2.17471e-13
  11 │ Santa Clara  732.077  56.2584
```
"""
function mean(x::Symbol, domain::Symbol, design::ReplicateDesign)
    weighted_mean(x, w) = mean(x, StatsBase.weights(w))
    df = bydomain(x, domain, design, weighted_mean)
    rename!(df, :statistic => :mean)
    return df
end
