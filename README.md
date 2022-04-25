# Survey

[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://xKDR.github.io/Survey.jl/dev)
![Build Status](https://github.com/xKDR/Survey.jl/actions/workflows/ci.yml/badge.svg)
![Build Status](https://github.com/xKDR/Survey.jl/actions/workflows/documentation.yml/badge.svg)
[![codecov](https://codecov.io/gh/xKDR/Survey}.jl/branch/main/graph/badge.svg?token=4PFSF47BT2)](https://codecov.io/gh/xKDR/Survey.jl)

This package is the Julia implementation of the [Survey package in R](https://cran.r-project.org/web/packages/survey/index.html) developed by [Professor Thomas Lumley](https://www.stat.auckland.ac.nz/people/tlum005). 

As the size of survey datasets have become larger, processing the records can take hours or days in R. We endeavour to solve this problem by implementing the Survey package in Julia.  

# To install:

    add "https://github.com/xKDR/Survey.jl.git"

## Basic usage:

```julia
using Survey

data(api)
## This function loads a commonly used dataset as an example. Any DataFrame object can be used. 

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