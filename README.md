# Survey

[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://xKDR.github.io/Survey.jl/dev)
![Build Status](https://github.com/xKDR/Survey.jl/actions/workflows/ci.yml/badge.svg)
![Build Status](https://github.com/xKDR/Survey.jl/actions/workflows/documentation.yml/badge.svg)
[![codecov](https://codecov.io/gh/xKDR/Survey.jl/branch/main/graph/badge.svg?token=4PFSF47BT2)](https://codecov.io/gh/xKDR/Survey.jl)
[![Milestones](https://img.shields.io/badge/-milestones-brightgreen)](https://github.com/xKDR/Survey.jl/milestones)


This package is used to study complex survey data. It aims to be a fast alternative to the [Survey package in R](https://cran.r-project.org/web/packages/survey/index.html) developed by [Professor Thomas Lumley](https://www.stat.auckland.ac.nz/people/tlum005).

This package currently supports simple random sample and stratified sample. In future releases, it will support multistage sampling as well. 

## How to install
```julia
]  add "https://github.com/xKDR/Survey.jl.git"
```
## Basic usage

### Simple Random Sample

In the following example, we will load a simple random sample of the Academic Performance Index dataset for Californian schools and do basic analysis. 
```julia
using Survey

srs = load_data("apisrs")

dsrs = SimpleRandomSample(srs; weights = :pw)

mean(:api00, dsrs)
1×2 DataFrame
 Row │ mean     SE      
     │ Float64  Float64 
─────┼──────────────────
   1 │ 656.585  9.24972

total(:enroll, dsrs)
1×2 DataFrame
 Row │ total      SE       
     │ Float64    Float64  
─────┼─────────────────────
   1 │ 3.62107e6  1.6952e5  

mean(:api00, :cname, dsrs)
38×3 DataFrame
 Row │ cname            mean     SE       
     │ String15         Float64  Float64  
─────┼────────────────────────────────────
   1 │ Kern             573.6     42.8026
   2 │ Los Angeles      658.156   21.0728
   3 │ Orange           749.333   27.0613
  ⋮  │        ⋮            ⋮        ⋮
  36 │ Napa             727.0     46.722
  37 │ Lake             804.0    NaN
  38 │ Merced           595.0    NaN

quantile(:enroll,dsrs,[0.1,0.2,0.5,0.75,0.95])
5×2 DataFrame
 Row │ probability  quantile 
     │ Float64      Float64  
─────┼───────────────────────
   1 │        0.1      245.5
   2 │        0.2      317.6
   3 │        0.5      453.0
   4 │        0.75     668.5
   5 │        0.95    1473.1
```

### Stratified Sample

In the following example, we will load a stratified sample of the Academic Performance Index dataset for Californian schools and do basic analysis. 

```julia
using Survey

strat = load_data("apistrat")

dstrat = StratifiedSample(strat, :stype; weights = :pw, popsize = :fpc)

mean(:api00, dstrat)
1×2 DataFrame
 Row │ mean     SE      
     │ Float64  Float64 
─────┼──────────────────
   1 │ 662.287  9.40894

total(:api00, dstrat)
1×2 DataFrame
 Row │ total      SE      
     │ Float64    Float64 
─────┼────────────────────
   1 │ 4.10221e6  58279.0

mean(:api00, :cname, dstrat)
40×3 DataFrame
 Row │ cname           mean     SE           
     │ String15        Float64  Float64      
─────┼───────────────────────────────────────
   1 │ Los Angeles     633.511  21.3912
   2 │ Ventura         707.172  31.6856
   3 │ Kern            678.235  53.1337
  ⋮  │       ⋮            ⋮          ⋮
  39 │ Mendocino       632.018   1.04942
  40 │ Butte           627.0     0.0
```

## Strategic goals
We want to implement all the features provided by the [Survey package in R](https://cran.r-project.org/web/packages/survey/index.html)

The [milestones](https://github.com/xKDR/Survey.jl/milestones) sections of the repository contains a list of features that contributors can implement in the short-term.

## Support

We gratefully acknowledge the JuliaLab at MIT for financial support for this project.
