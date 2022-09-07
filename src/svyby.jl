"""
The `svyby` function can be used to generate subsets of a survey design.

```jldoctest
julia> using Survey

julia> apisrs = load_data("apisrs");

julia> srs = SimpleRandomSample(apisrs);

julia> svyby(:api00, :cname, srs, svytotal)
38×2 DataFrame
 Row │ cname            total
     │ String15         Float64
─────┼──────────────────────────
   1 │ Kern              5736.0
   2 │ Los Angeles      29617.0
   3 │ Orange            6744.0
   4 │ San Luis Obispo    739.0
   5 │ San Francisco     1675.0
   6 │ Modoc              671.0
   7 │ Alameda           7437.0
   8 │ Solano            1869.0
  ⋮  │        ⋮            ⋮
  32 │ Kings              939.0
  33 │ Shasta            1508.0
  34 │ Yolo               475.0
  35 │ Calaveras          790.0
  36 │ Napa              1454.0
  37 │ Lake               804.0
  38 │ Merced             595.0
                 23 rows omitted
```
"""
# TODO: functionality for `formula::AbstractVector`
function svyby(formula::Symbol, by::Symbol, design::AbstractSurveyDesign, func::Function, params = [])
    gdf = groupby(design.data, by)
    return combine(gdf, [formula, :weights] => ((a, b) -> func(a, design, b, params...)) => AsTable)
end