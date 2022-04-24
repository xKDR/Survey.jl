"""
```jldoctest
julia> using Survey, Statistics, StatsBase;   

julia> load_sample_data(); 

julia> dclus1 = svydesign(id=:dnum, weights=:pw, data = apiclus1, fpc=:fpc);

julia> svyby(:api00, dclus1, mean)
644.1693989071047
```
"""
function svyby(formula::Symbol, design::svydesign, func::Function, params = [])
    data = design.data
    x = design.data[!, string(formula)]
    w = design.data[!, string(design.weights)]
    return func(x, weights(w), params...)
end

"""
```jldoctest
julia> using Survey, Statistics, StatsBase;        

julia> load_sample_data(); 

julia> dclus1 = svydesign(id=:dnum, weights=:pw, data = apiclus1, fpc=:fpc); 

julia> svyby(:api00, :cname, dclus1, mean)
11×2 DataFrame
 Row │ cname        api00   
     │ String15     Float64 
─────┼──────────────────────
   1 │ Alameda      669.0
   2 │ Fresno       472.0
   3 │ Kern         452.5
   4 │ Los Angeles  647.267
   5 │ Mendocino    623.25
   6 │ Merced       519.25
   7 │ Orange       710.563
   8 │ Plumas       709.556
   9 │ San Diego    659.436
  10 │ San Joaquin  551.189
  11 │ Santa Clara  732.077
```
"""
function svyby(formula::Symbol, by::Symbol, design::svydesign, func::Function, params = [])
    gdf = groupby(design.data, by)
    w = design.weights
    return combine(gdf, [formula, w] => ((x, y) -> func(x, weights(y), params...)) => formula)
end


