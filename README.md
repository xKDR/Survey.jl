# Survey

[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://xKDR.github.io/Survey.jl/dev)
![Build Status](https://github.com/xKDR/Survey.jl/actions/workflows/ci.yml/badge.svg)
![Build Status](https://github.com/xKDR/Survey.jl/actions/workflows/documentation.yml/badge.svg)
[![codecov](https://codecov.io/gh/xKDR/Survey.jl/branch/main/graph/badge.svg?token=4PFSF47BT2)](https://codecov.io/gh/xKDR/Survey.jl)

This package is used to study stratified survey data. It is the Julia implementation of the [Survey package in R](https://cran.r-project.org/web/packages/survey/index.html) developed by [Professor Thomas Lumley](https://www.stat.auckland.ac.nz/people/tlum005). 

As the size of survey datasets have become larger, processing the records can take hours or days in R. We endeavour to solve this problem by implementing the Survey package in Julia.  

# To install:

    add "https://github.com/xKDR/Survey.jl.git"

# Basic usage:

In the following example, we will load the Academic Performance Index dataset for Californian schools and produce the weighted mean for each county.  
```julia
using Survey

data(api)
## This function loads a commonly used dataset, Academic Performance Index (API), as an example.
## Any DataFrame object can be used with this package. 

dclus1 = svydesign(id = :dnum, weights = :pw, data = apiclus1, fpc = :fpc)

svyby(:api00, :cname, dclus1, svymean)
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

This example is from the Survey package in R. The [examples section of the documentation](https://xkdr.github.io/Survey.jl/dev/examples/) shows the R and the Julia code side by side for this and a few other examples. 

# Performance
We will measure the performance of the R and Julia for example shown above. 

**R**

```R
> library(survey)
> library(microbenchmark)
> data(api)
> dclus1 <- svydesign(id = ~dnum, weights = ~pw, data = apiclus1, fpc = ~fpc)
> microbenchmark(svyby(~api00, by = ~cname, design = dclus1, svymean, keep.var = FALSE), units = "us")
```

```R
Unit: microseconds
                                                                   expr
 svyby(~api00, by = ~cname, design = dclus1, svymean, keep.var = FALSE)
      min       lq     mean   median       uq      max neval
 9427.043 10587.81 11269.22 10938.55 11219.24 17620.25   100
```

**Julia**
```julia
using Survey, BenchmarkTools      
data(api)
dclus1 = svydesign(id=:dnum, weights=:pw, data = apiclus1, fpc=:fpc)
@benchmark svyby(:api00, :cname, dclus1, svymean)
```

```julia
BenchmarkTools.Trial: 10000 samples with 1 evaluation.
 Range (min … max):  43.567 μs …   5.905 ms  ┊ GC (min … max): 0.00% … 90.27%
 Time  (median):     53.680 μs               ┊ GC (median):    0.00%
 Time  (mean ± σ):   58.090 μs ± 125.671 μs  ┊ GC (mean ± σ):  4.36% ±  2.00%
 ```

**The median time is about 198 times lower in Julia as compared to R.** 

### We increase the complexity to grouby two variables and then perform the same operations.

**R**

```R
> library(survey)
> library(microbenchmark)
> data(api)
> dclus1 <- svydesign(id = ~dnum, weights = ~pw, data = apiclus1, fpc = ~fpc)
> microbenchmark(svyby(~api00, by = ~cname+meals, design = dclus1, svymean, keep.var = FALSE), units = "us")
```

```R
Unit: microseconds
                                                                                expr
 svyby(~api00, by = ~cname + meals, design = dclus1, svymean,      keep.var = FALSE)
      min       lq     mean   median       uq      max neval
 120823.6 131472.8 141797.3 134375.8 140818.3 263964.3   100
```

**Julia**
```julia
using Survey, BenchmarkTools      
data(api)
dclus1 = svydesign(id=:dnum, weights=:pw, data = apiclus1, fpc=:fpc)
@benchmark svyby(:api00, [:cname, :meals], dclus1, svymean)
```

```julia
BenchmarkTools.Trial: 10000 samples with 1 evaluation.
 Range (min … max):  64.591 μs …   6.559 ms  ┊ GC (min … max): 0.00% … 77.46%
 Time  (median):     78.204 μs               ┊ GC (median):    0.00%
 Time  (mean ± σ):   89.447 μs ± 235.344 μs  ┊ GC (mean ± σ):  8.48% ±  3.19%
 ```

 **The median time is about 1718 times lower in Julia as compared to R.** 
