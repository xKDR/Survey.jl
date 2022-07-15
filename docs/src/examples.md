# Examples

The following examples use the Academic Performance Index (API) dataset for Californian schools.

## Julia code

```julia
using Survey

data(api)
dclus1 = svydesign(id = :1, weights = :pw, data = apiclus1)
svyby(:api00, :cname, dclus1, svymean)

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
