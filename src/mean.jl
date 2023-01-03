"""
```jldoctest
julia> using Survey, Random, StatsBase; 

julia> apiclus1 = load_data("apiclus1"); 

julia> dclus1 = SurveyDesign(apiclus1, :dnum, :fpc); 

julia> bclus1 = bootweights(apiclus1; replicates = 1000)

julia> mean(:api00, bclus1)
1×2 DataFrame
 Row │ mean     SE      
     │ Float64  Float64 
─────┼──────────────────
   1 │ 644.169  23.0897
```
"""
function mean(x::Symbol, design::ReplicateDesign)
    X = mean(design.data[!, x], weights(design.data.weights))
    Xt = [mean(design.data[!, x], weights(design.data.weights .* design.data[! , "replicate_"*string(i)])) for i in 1:design.replicates]
    variance = sum((Xt .- X).^2) / design.replicates
    DataFrame(mean = X, SE = sqrt(variance))
end
"""
```jldoctest
julia> using Survey, Random, StatsBase; 

julia> apiclus1 = load_data("apiclus1"); 

julia> dclus1 = SurveyDesign(apiclus1, :dnum, :fpc); 

julia> bclus1 = bootweights(apiclus1; replicates = 1000)

julia> mean(:api00, :cname, bclus1) |> print
38×3 DataFrame
 Row │ cname            statistic  SE          
     │ String15         Float64    Any         
─────┼─────────────────────────────────────────
   1 │ Kern               573.6    44.5578
   2 │ Los Angeles        658.156  22.2058
   3 │ Orange             749.333  29.5701
   4 │ San Luis Obispo    739.0    3.37273e-14
   5 │ San Francisco      558.333  45.6266
   6 │ Modoc              671.0    0.0
   7 │ Alameda            676.091  37.3104
   8 │ Solano             623.0    45.1222
   9 │ Santa Cruz         624.333  113.43
  10 │ Monterey           605.0    85.4116
  11 │ San Bernardino     614.462  30.0066
  12 │ Riverside          574.3    27.2025
  13 │ Tulare             664.0    22.0097
  14 │ San Diego          684.5    32.2241
  15 │ Sacramento         616.0    39.7877
  16 │ Marin              799.667  35.2397
  17 │ Imperial           622.0    0.0
  18 │ Ventura            743.8    31.7425
  19 │ San Joaquin        608.667  40.8592
  20 │ Sonoma             630.0    0.0
  21 │ Fresno             600.25   56.9173
  22 │ Santa Clara        718.286  58.562
  23 │ Sutter             744.0    0.0
  24 │ Contra Costa       766.111  53.598
  25 │ Stanislaus         736.333  5.26576
  26 │ Madera             480.0    3.5861
  27 │ Placer             759.0    0.0
  28 │ Lassen             752.0    0.0
  29 │ Santa Barbara      728.667  25.8749
  30 │ San Mateo          617.0    78.1173
  31 │ Siskiyou           699.0    0.0
  32 │ Kings              469.5    44.6284
  33 │ Shasta             754.0    60.5829
  34 │ Yolo               475.0    0.0
  35 │ Calaveras          790.0    0.0
  36 │ Napa               727.0    50.5542
  37 │ Lake               804.0    0.0
  38 │ Merced             595.0    0
```
"""
function mean(x::Symbol, domain::Symbol, design::ReplicateDesign)
    weighted_mean(x, w) = mean(x, StatsBase.weights(w))
    df = bydomain(x, domain, design, weighted_mean)
    rename!(df, :statistic => :mean)
    return df
end

function mean(x::Vector{Symbol}, design::ReplicateDesign)
    df = reduce(vcat, [mean(i, design) for i in x])
    insertcols!(df, 1, :names => String.(x))
    return df
end