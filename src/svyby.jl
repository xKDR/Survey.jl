
function svymean(x, w, popsize, sampsize)
    # popsize correction isn't implemented yet
    ss = maximum(sampsize)
    function SE(x, w, ss)
        f = sqrt(1 - 1/length(x) + 1/ss)
        var = sum(w.*(x.- sum(w.*x)/sum(w)).^2)/sum(w)
        sd = sqrt(var / (length(x) -1))
        return f * sd
    end
   return DataFrame(mean = mean(x, weights(w)), SE = SE(x, w, ss))
end

svyquantile = function(x, w, popsize, sampsize, q)
    df = DataFrame(tmp = quantile(Float32.(x), weights(w), q))
    rename!(df,:tmp => Symbol(string(q) .* "th percentile"))
    return df
end


svytotal = function(x, w, popsize, sampsize)
    df = DataFrame(total = wsum(Float32.(x), weights(1 ./ w)))
    return df
end

"""
The `svyby` function can be used to generate stratified estimates.

```jldoctest
julia> using Survey      

julia> data(api); 

julia> dclus1 = svydesign(id=:1, weights=:pw, data = apiclus1); 

julia> svyby(:api00, :cname, dclus1, svymean)
11×3 DataFrame
 Row │ cname        mean     SE
     │ String15     Float64  Float64
─────┼────────────────────────────────
   1 │ Alameda      669.0    16.2135
   2 │ Fresno       472.0     9.85278
   3 │ Kern         452.5    29.5049
   4 │ Los Angeles  647.267  23.5116
   5 │ Mendocino    623.25   24.216
   6 │ Merced       519.25   10.4925
   7 │ Orange       710.562  28.9123
   8 │ Plumas       709.556  13.2174
   9 │ San Diego    659.436  12.2082
  10 │ San Joaquin  551.189  11.578
  11 │ Santa Clara  732.077  12.2291
```

julia> svyby(:api00, [:cname, :meals], dclus1, svymean); 
"""
function svyby(formula::Symbol, by, design::svydesign, func::Function, params = [])
    gdf = groupby(design.variables, by)
    return combine(gdf, [formula, :probs, :popsize, :sampsize] => ((a, b, c, d) -> func(a, b, c, d, params...)) => AsTable)
end
