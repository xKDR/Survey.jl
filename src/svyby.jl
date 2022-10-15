"""
The `svyby` function can be used to generate subsets of a survey design.

```jldoctest
julia> using Survey

julia> apisrs = load_data("apisrs");

julia> srs = SimpleRandomSample(apisrs);

julia> svyby(:api00, :cname, srs, svytotal)
38×3 DataFrame
 Row │ cname            total    se_total
     │ String15         Float64  Float64
─────┼────────────────────────────────────
   1 │ Kern              5736.0  2045.98
   2 │ Los Angeles      29617.0  2050.04
   3 │ Orange            6744.0  1234.81
   4 │ San Luis Obispo    739.0   NaN
   5 │ San Francisco     1675.0  1193.85
   6 │ Modoc              671.0   NaN
   7 │ Alameda           7437.0  1633.82
   8 │ Solano            1869.0  1219.59
  ⋮  │        ⋮            ⋮        ⋮
  32 │ Kings              939.0  1190.0
  33 │ Shasta            1508.0  1600.0
  34 │ Yolo               475.0   NaN
  35 │ Calaveras          790.0   NaN
  36 │ Napa              1454.0  1340.0
  37 │ Lake               804.0   NaN
  38 │ Merced             595.0   NaN
                           23 rows omitted
```
"""
function svyby(formula::Symbol, by::Symbol, design::AbstractSurveyDesign, func::Function, params = [])
    # TODO: add functionality for `formula::AbstractVector`
    gdf = groupby(design.data, by)
    return combine(gdf, [formula, :weights] => ((a, b) -> func(a, design, b, params...)) => AsTable)
end
