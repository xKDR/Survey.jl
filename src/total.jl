"""
```jldoctest
julia> using Survey; 

julia> apiclus1 = load_data("apiclus1"); 

julia> dclus1 = SurveyDesign(apiclus1; clusters = :dnum, weights = :pw); 

julia> bclus1 = bootweights(dclus1; replicates = 1000); 

julia> total(:api00, bclus1)
1×2 DataFrame
 Row │ mean       SE        
     │ Float64    Float64   
─────┼──────────────────────
   1 │ 5.94916e6  2.01705e6
```
"""
function total(x::Symbol, design::ReplicateDesign)
    X = wsum(design.data[!, x], weights(design.data.weights))
    Xt = [wsum(design.data[!, x], weights(design.data.weights .* design.data[! , "replicate_"*string(i)])) for i in 1:design.replicates]
    variance = sum((Xt .- X).^2) / design.replicates
    DataFrame(total = X, SE = sqrt(variance))
end
"""
```jldoctest
julia> using Survey; 

julia> apiclus1 = load_data("apiclus1"); 

julia> dclus1 = SurveyDesign(apiclus1; clusters = :dnum, weights = :pw); 

julia> bclus1 = bootweights(dclus1; replicates = 1000); 

julia> total(:api00, :cname, bclus1) |> print
11×3 DataFrame
 Row │ cname        statistic      SE        
     │ String15     Float64        Any       
─────┼───────────────────────────────────────
   1 │ Alameda          3.71384e5  3.78375e5
   2 │ Fresno       95281.1        96134.8
   3 │ Kern         45672.3        43544.7
   4 │ Los Angeles      4.89981e5  4.42865e5
   5 │ Mendocino        1.25813e5  1.22757e5
   6 │ Merced           1.04819e5  1.09032e5
   7 │ Orange           5.73756e5  6.01213e5
   8 │ Plumas           3.2228e5   3.26443e5
   9 │ San Diego        1.83038e6  1.34155e6
  10 │ San Joaquin      1.02922e6  1.04048e6
  11 │ Santa Clara      9.60583e5  643492.0
```
"""
function total(x::Symbol, domain::Symbol, design::ReplicateDesign)
    bydomain(x, domain, design, wsum)
end