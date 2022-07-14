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

## R code

```R
> library(survey)
> data(api)
> dclus1 <- svydesign(id = ~1, weights = ~pw, data = apiclus1)
> svyby(~api00, by = ~cname, design = dclus1, svymean)

                  cname    api00       se
Alameda         Alameda 669.0000 16.20930
Fresno           Fresno 472.0000  9.84401
Kern               Kern 452.5000 29.42544
Los Angeles Los Angeles 647.2667 23.50738
Mendocino     Mendocino 623.2500 24.19443
Merced           Merced 519.2500 10.48320
Orange           Orange 710.5625 28.90751
Plumas           Plumas 709.5556 13.21311
San Diego     San Diego 659.4364 12.20777
San Joaquin San Joaquin 551.1892 11.57730
Santa Clara Santa Clara 732.0769 12.22800

