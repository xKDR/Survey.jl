# Survey

[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://xKDR.github.io/Survey.jl/dev)
![Build Status](https://github.com/xKDR/Survey.jl/actions/workflows/ci.yml/badge.svg)
![Build Status](https://github.com/xKDR/Survey.jl/actions/workflows/documentation.yml/badge.svg)
[![codecov](https://codecov.io/gh/xKDR/Survey.jl/branch/main/graph/badge.svg?token=4PFSF47BT2)](https://codecov.io/gh/xKDR/Survey.jl)
[![Milestones](https://img.shields.io/badge/-milestones-brightgreen)](https://github.com/xKDR/Survey.jl/milestones)


This package is used to study complex survey data. It is the Julia implementation of the [Survey package in R](https://cran.r-project.org/web/packages/survey/index.html) developed by [Professor Thomas Lumley](https://www.stat.auckland.ac.nz/people/tlum005).

As the size of survey datasets have become larger, processing the records can take hours or days in R. We endeavour to solve this problem by implementing the Survey package in Julia.

## How to install

    add "https://github.com/xKDR/Survey.jl.git"

## Basic usage

In the following example, we will load the Academic Performance Index dataset for Californian schools and produce the weighted mean for each county.
```julia
using Survey

apiclus1 = load_data("apiclus1")
## This function loads a commonly used dataset, Academic Performance Index (API), as an example.
## Any DataFrame object can be used with this package.

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

This example is from the Survey package in R. The [examples section of the documentation](https://xkdr.github.io/Survey.jl/dev/examples/) shows the R and the Julia code side by side for this and a few other examples.

## Performance
We will measure the performance of the R and Julia for the example shown above.

**R**

```R
library(survey)
library(microbenchmark)
data(api)
dclus1 <- svydesign(id = ~1, weights = ~pw, data = apiclus1)
microbenchmark(svyby(~api00, by = ~cname, design = dclus1, svymean), units = "us")
```

```R
                                                 expr      min       lq
 svyby(~api00, by = ~cname, design = dclus1, svymean) 10180.47 12102.61
     mean   median       uq      max neval
 12734.43 12421.93 12788.55 17242.35   100
```

**Julia**
```julia
using Survey, BenchmarkTools
apiclus1 = load_data("apiclus1")
dclus1 = svydesign(id=:1, weights=:pw, data = apiclus1)
@benchmark svyby(:api00, :cname, dclus1, svymean)
```

```julia
BenchmarkTools.Trial: 10000 samples with 1 evaluation.
 Range (min … max):  54.464 μs …   6.070 ms  ┊ GC (min … max): 0.00% … 94.01%
 Time  (median):     72.468 μs               ┊ GC (median):    0.00%
 Time  (mean ± σ):   81.833 μs ± 190.657 μs  ┊ GC (mean ± σ):  7.62% ±  3.23%
 ```

The Julia code is about 171 times faster than the R code.

We increase the complexity by grouping the data by two variables and then performing the same operations.
**R**

```R
library(survey)
library(microbenchmark)
data(api)
dclus1 <- svydesign(id = ~1, weights = ~pw, data = apiclus1)
microbenchmark(svyby(~api00, by = ~cname+meals, design = dclus1, svymean, keep.var = FALSE), units = "us")
```

```R
Unit: microseconds
                                                         expr      min     lq
 svyby(~api00, by = ~cname + meals, design = dclus1, svymean) 132468.1 149914
     mean   median       uq      max neval
 166121.9 160571.3 172301.6 304979.2   100
```

**Julia**
```julia
using Survey, BenchmarkTools
apiclus1 = load_data("apiclus1")
dclus1 = svydesign(id=:1, weights=:pw, data = apiclus1)
@benchmark svyby(:api00, [:cname, :meals], dclus1, svymean)
```

```julia
BenchmarkTools.Trial: 10000 samples with 1 evaluation.
 Range (min … max):  219.387 μs …   8.284 ms  ┊ GC (min … max):  0.00% … 90.94%
 Time  (median):     265.214 μs               ┊ GC (median):     0.00%
 Time  (mean ± σ):   325.100 μs ± 513.020 μs  ┊ GC (mean ± σ):  14.23% ±  8.58%
 ```

The Julia code is about 605 times faster than the R code.

## Strategic goals

We want to implement all the features provided by the [Survey package in R](https://cran.r-project.org/web/packages/survey/index.html)

The [milestones](https://github.com/xKDR/Survey.jl/milestones) sections of the repository contains a list of features that contributors can implement in the short-term.

## Support

We gratefully acknowledge the JuliaLab at MIT for financial support for this project.
