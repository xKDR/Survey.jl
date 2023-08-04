# Survey

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://xKDR.github.io/Survey.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://xKDR.github.io/Survey.jl/dev)
![Build Status](https://github.com/xKDR/Survey.jl/actions/workflows/ci.yml/badge.svg)
![Build Status](https://github.com/xKDR/Survey.jl/actions/workflows/documentation.yml/badge.svg)
[![codecov](https://codecov.io/gh/xKDR/Survey.jl/branch/main/graph/badge.svg?token=4PFSF47BT2)](https://codecov.io/gh/xKDR/Survey.jl)
[![Milestones](https://img.shields.io/badge/-milestones-brightgreen)](https://github.com/xKDR/Survey.jl/milestones)

This package is used to study complex survey data. It aims to provide an efficient computing framework for large survey data. 
All types of survey design are supported by this package.

> **_NOTE:_**  For multistage sampling a single stage approximation is used.[^1]

## Installation
```julia
]  add Survey
```

## Basic usage

The `SurveyDesign` constructor can take data corresponding to any type of design.
Depending on the keyword arguments passed, the data is processed in order to obtain
correct results for the given design.

The following examples show how to create and manipulate different survey designs
using the [Academic Performance Index dataset for Californian schools](https://r-survey.r-forge.r-project.org/survey/html/api.html).

### Constructing a survey design

A survey design can be created by calling the constructor with some keywords,
depending on the survey type. Let's create a simple random sample, a stratified
sample, a single-stage and a two-stage cluster sample.

```julia
julia> apisrs = load_data("apisrs");

julia> srs = SurveyDesign(apisrs; weights=:pw)
SurveyDesign:
data: 200×47 DataFrame
strata: none
cluster: none
popsize: [6190.0, 6190.0, 6190.0  …  6190.0]
sampsize: [200, 200, 200  …  200]
weights: [31.0, 31.0, 31.0  …  31.0]
probs: [0.0323, 0.0323, 0.0323  …  0.0323]

julia> apistrat = load_data("apistrat");

julia> dstrat = SurveyDesign(apistrat; strata=:stype, weights=:pw)
SurveyDesign:
data: 200×46 DataFrame
strata: stype
    [E, E, E  …  H]
cluster: none
popsize: [6190.0, 6190.0, 6190.0  …  6190.0]
sampsize: [200, 200, 200  …  200]
weights: [44.2, 44.2, 44.2  …  15.1]
probs: [0.0226, 0.0226, 0.0226  …  0.0662]

julia> apiclus1 = load_data("apiclus1");

julia> dclus1 = SurveyDesign(apiclus1; clusters=:dnum, weights=:pw)
SurveyDesign:
data: 183×46 DataFrame
strata: none
cluster: dnum
    [637, 637, 637  …  448]
popsize: [6190.0, 6190.0, 6190.0  …  6190.0]
sampsize: [15, 15, 15  …  15]
weights: [33.8, 33.8, 33.8  …  33.8]
probs: [0.0295, 0.0295, 0.0295  …  0.0295]

julia> apiclus2 = load_data("apiclus2");

julia> dclus2 = SurveyDesign(apiclus2; clusters=[:dnum, :snum], weights=:pw)
SurveyDesign:
data: 126×47 DataFrame
strata: none
cluster: dnum
    [15, 63, 83  …  795]
popsize: [5130.0, 5130.0, 5130.0  …  5130.0]
sampsize: [40, 40, 40  …  40]
weights: [18.9, 18.9, 18.9  …  18.9]
probs: [0.0528, 0.0528, 0.0528  …  0.0528]
```

Using these designs we can compute estimates of statistics such as mean and
population total. The designs must first be resampled using
[bootstrapping](https://en.wikipedia.org/wiki/Bootstrapping_(statistics)) in order
to compute the standard errors.

```julia
julia> bootsrs = bootweights(srs; replicates=1000)
ReplicateDesign{BootstrapReplicates}:
data: 200×1047 DataFrame
strata: none
cluster: none
popsize: [6190.0, 6190.0, 6190.0  …  6190.0]
sampsize: [200, 200, 200  …  200]
weights: [31.0, 31.0, 31.0  …  31.0]
allprobs: [0.0323, 0.0323, 0.0323  …  0.0323]
type: bootstrap
replicates: 1000

julia> mean(:api00, bootsrs)
1×2 DataFrame
 Row │ mean     SE
     │ Float64  Float64
─────┼──────────────────
   1 │ 656.585   9.5409

julia> total(:enroll, bootsrs)
1×2 DataFrame
 Row │ total      SE
     │ Float64    Float64
─────┼──────────────────────
   1 │ 3.62107e6  1.72846e5
```

Now we know the mean academic performance index from the year 2000 and the total
number of students enrolled in the sampled Californian schools. We can also
calculate the statistic of multiple variables in one go...

```julia
julia> mean([:api99, :api00], bootsrs)
2×3 DataFrame
 Row │ names   mean     SE
     │ String  Float64  Float64
─────┼──────────────────────────
   1 │ api99   624.685  9.84669
   2 │ api00   656.585  9.5409
```

... and we can also calculate domain estimates:

```julia
julia> total(:enroll, :cname, bootsrs)
38×3 DataFrame
 Row │ cname            total           SE
     │ String15         Float64         Any
─────┼────────────────────────────────────────────
   1 │ Kern                  1.95823e5  74731.2
   2 │ Los Angeles      867129.0        1.36622e5
   3 │ Orange                1.68786e5  63858.0
   4 │ San Luis Obispo    6720.49       6790.49
  ⋮  │        ⋮               ⋮             ⋮
  35 │ Calaveras         12976.4        13241.6
  36 │ Napa              39239.0        30181.9
  37 │ Lake               6410.79       6986.29
  38 │ Merced            15392.1        15202.2
                                   30 rows omitted
```

This gives us the total number of enrolled students in each county.

All functionalities are supported by each design type.

## Goals

We want to implement all the features provided by the
[Survey package in R](https://cran.r-project.org/web/packages/survey/index.html)
in a Julia-native way. The main goal is to have a complete package that provides
a large range of functionality and takes efficiency into consideration for
large surveys to be analysed fast.

The [milestones](https://github.com/xKDR/Survey.jl/milestones) section of the repository
contains a list of features that contributors can implement in the short-term. Please see [contributing guidelines](https://github.com/xKDR/Survey.jl/blob/main/CONTRIBUTING.md) on how to contribute to the project.

## Support

We gratefully acknowledge the JuliaLab at MIT for financial support for this project.

## References

[^1]: [Lumley, Thomas. Complex surveys: a guide to analysis using R. John Wiley & Sons, 2011.](https://books.google.co.in/books?hl=en&lr=&id=L96ludyhFBsC&oi=fnd&pg=PP12&dq=complex+surveys+lumley&ots=ie0y1lnzv1&sig=c4UHI3arjspMJ6OYzlX32E9rNRI#v=onepage&q=complex%20surveys%20lumley&f=false) Page 44
