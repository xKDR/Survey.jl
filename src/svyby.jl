"""
    svyby(formula, by, design, function, params)

Generate subsets of a survey design.

```jldoctest
julia> apisrs = load_data("apisrs");

julia> srs = SimpleRandomSample(apisrs; weights = :pw);

julia> svyby(:api00, :cname, srs, svymean)
38×3 DataFrame
 Row │ cname            mean     sem     
     │ String15         Float64  Float64 
─────┼───────────────────────────────────
   1 │ Kern             573.6    179.646
   2 │ Los Angeles      658.156   87.585
   3 │ Orange           749.333  241.821
   4 │ San Luis Obispo  739.0    NaN
   5 │ San Francisco    558.333  318.351
   6 │ Modoc            671.0    NaN
   7 │ Alameda          676.091  197.927
   8 │ Solano           623.0    354.57
  ⋮  │        ⋮            ⋮        ⋮
  32 │ Kings            469.5    330.175
  33 │ Shasta           754.0    527.752
  34 │ Yolo             475.0    NaN
  35 │ Calaveras        790.0    NaN
  36 │ Napa             727.0    507.463
  37 │ Lake             804.0    NaN
  38 │ Merced           595.0    NaN
                          23 rows omitted
```
"""
function svyby(formula::Symbol, by::Symbol, design::AbstractSurveyDesign, func::Function, params = [])
    # TODO: add functionality for `formula::AbstractVector`
    gdf = groupby(design.data, by)
    return combine(gdf, [formula, :weights] => ((a, b) -> func(a, design, b, params...)) => AsTable)
end
