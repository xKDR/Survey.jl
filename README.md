# Survey

[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://xKDR.github.io/Survey.jl/dev)
![Build Status](https://github.com/xKDR/Survey.jl/actions/workflows/ci.yml/badge.svg)
![Build Status](https://github.com/xKDR/Survey.jl/actions/workflows/documentation.yml/badge.svg)
[![codecov](https://codecov.io/gh/xKDR/Survey.jl/branch/main/graph/badge.svg?token=4PFSF47BT2)](https://codecov.io/gh/xKDR/Survey.jl)
[![Milestones](https://img.shields.io/badge/-milestones-brightgreen)](https://github.com/xKDR/Survey.jl/milestones)

This package is used to study complex survey data. It aims to be a fast alternative
to the [Survey package in R](https://cran.r-project.org/web/packages/survey/index.html)
developed by [Professor Thomas Lumley](https://www.stat.auckland.ac.nz/people/tlum005).

This package currently supports simple random sample, stratified sample, one- and
two-stage cluster sample. In future releases, it will support multistage sampling as well.

## Installation
```julia
]  add "https://github.com/xKDR/Survey.jl.git"
```

## Basic usage

The `SurveyDesign` constructor can take data corresponding to any type of design.
Depending on the keyword arguments passed, the data is processed in order to obtain
correct results for the given design.

The following examples show how to create and manipulate different survey designs
using the [Academic Performance Index dataset for Californian schools](https://r-survey.r-forge.r-project.org/survey/html/api.html).

### Simple random sample

A simple random sample can be created without specifying any special keywords. Here
we will create a weighted simple random sample design.

```julia
julia> apisrs = load_data("apisrs");

julia> srs = SurveyDesign(apisrs; weights=:pw)
SurveyDesign:
data: 200x47 DataFrame
cluster: false_cluster
design.data[!,design.cluster]: 1, 2, 3, ..., 200
popsize: popsize
design.data[!,design.popsize]: 6190.0, 6190.0, 6190.0, ..., 6190.0
sampsize: sampsize
design.data[!,design.sampsize]: 200, 200, 200, ..., 200
design.data[!,:probs]: 0.0323, 0.0323, 0.0323, ..., 0.0323
design.data[!,:allprobs]: 0.0323, 0.0323, 0.0323, ..., 0.0323
```

Using the `srs` design we can compute estimates of statistics such as mean and
population total. The design must first be resampled using
[bootstrapping](https://en.wikipedia.org/wiki/Bootstrapping_(statistics)) in order
to compute the standard errors.

```julia
julia> bootsrs = bootweights(srs; replicates=1000)
ReplicateDesign:
data: 200x1047 DataFrame
cluster: false_cluster
design.data[!,design.cluster]: 1, 2, 3, ..., 200
popsize: popsize
design.data[!,design.popsize]: 6190.0, 6190.0, 6190.0, ..., 6190.0
sampsize: sampsize
design.data[!,design.sampsize]: 200, 200, 200, ..., 200
design.data[!,:probs]: 0.0323, 0.0323, 0.0323, ..., 0.0323
design.data[!,:allprobs]: 0.0323, 0.0323, 0.0323, ..., 0.0323
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
calculate the statistic of two variables in one go...

```julia
julia> mean([:api99, :api00], bootsrs)
2×3 DataFrame
 Row │ names   mean     SE
     │ String  Float64  Float64
─────┼──────────────────────────
   1 │ api99   624.685  9.84669
   2 │ api00   656.585  9.5409
```

... or we can calculate domain estimates:

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

### Stratified sample

All functionalities described above are also supported for stratified sample
designs. To create a stratified sample, the `strata` keyword must be passed to
`SurveyDesign`.

```julia
julia> apistrat = load_data("apistrat");

julia> strat = SurveyDesign(apistrat; strata=:stype, weights=:pw)
SurveyDesign:
data: 200x46 DataFrame
cluster: false_cluster
design.data[!,design.cluster]: 1, 2, 3, ..., 200
popsize: popsize
design.data[!,design.popsize]: 6190.0, 6190.0, 6190.0, ..., 6190.0
sampsize: sampsize
design.data[!,design.sampsize]: 200, 200, 200, ..., 200
design.data[!,:probs]: 0.0226, 0.0226, 0.0226, ..., 0.0662
design.data[!,:allprobs]: 0.0226, 0.0226, 0.0226, ..., 0.0662


julia> bootstrat = bootweights(strat; replicates=1000)
ReplicateDesign:
data: 200x1046 DataFrame
cluster: false_cluster
design.data[!,design.cluster]: 1, 2, 3, ..., 200
popsize: popsize
design.data[!,design.popsize]: 6190.0, 6190.0, 6190.0, ..., 6190.0
sampsize: sampsize
design.data[!,design.sampsize]: 200, 200, 200, ..., 200
design.data[!,:probs]: 0.0226, 0.0226, 0.0226, ..., 0.0662
design.data[!,:allprobs]: 0.0226, 0.0226, 0.0226, ..., 0.0662
replicates: 1000


julia> mean([:api99, :api00], bootstrat)
2×3 DataFrame
 Row │ names   mean     SE
     │ String  Float64  Float64
─────┼───────────────────────────
   1 │ api99   629.395  10.08
   2 │ api00   662.287   9.56931

julia> mean(:api00, :cname, bootstrat)
40×3 DataFrame
 Row │ cname           mean     SE
     │ String15        Float64  Any
─────┼──────────────────────────────────
   1 │ Los Angeles     633.511  21.6242
   2 │ Ventura         707.172  34.2091
   3 │ Kern            678.235  57.651
   4 │ San Diego       704.121  33.0882
  ⋮  │       ⋮            ⋮        ⋮
  37 │ Napa            660.0    0.0
  38 │ Mariposa        706.0    0.0
  39 │ Mendocino       632.018  1.70573
  40 │ Butte           627.0    0.0
                         32 rows omitted
```

### Cluster sample

For now, the package supports one- and two-stage cluster sampling. These are
created by passing the `clusters` keyword argument to `SurveyDesign`.

```julia
julia> apiclus1 = load_data("apiclus1");

julia> clus_one_stage = SurveyDesign(apiclus1; clusters=:dnum, weights=:pw)
SurveyDesign:
data: 183x46 DataFrame
cluster: dnum
design.data[!,design.cluster]: 637, 637, 637, ..., 448
popsize: popsize
design.data[!,design.popsize]: 6190.0, 6190.0, 6190.0, ..., 6190.0
sampsize: sampsize
design.data[!,design.sampsize]: 15, 15, 15, ..., 15
design.data[!,:probs]: 0.0295, 0.0295, 0.0295, ..., 0.0295
design.data[!,:allprobs]: 0.0295, 0.0295, 0.0295, ..., 0.0295


julia> apiclus2 = load_data("apiclus2");

julia> clus_two_stage = SurveyDesign(apiclus2; clusters=[:dnum, :snum], weights=:pw)
SurveyDesign:
data: 126x47 DataFrame
cluster: dnum
design.data[!,design.cluster]: 15, 63, 83, ..., 795
popsize: popsize
design.data[!,design.popsize]: 5130.0, 5130.0, 5130.0, ..., 5130.0
sampsize: sampsize
design.data[!,design.sampsize]: 40, 40, 40, ..., 40
design.data[!,:probs]: 0.0528, 0.0528, 0.0528, ..., 0.0528
design.data[!,:allprobs]: 0.0528, 0.0528, 0.0528, ..., 0.0528
```

Again, all above functionalities are supported for cluster sample designs as well.

```julia
julia> bootclus_one_stage = bootweights(clus_one_stage; replicates=1000);

julia> total([:enroll, Symbol("api.stu")], bootclus_one_stage)
2×3 DataFrame
 Row │ names    total      SE
     │ String   Float64    Float64
─────┼───────────────────────────────
   1 │ enroll   3.40494e6  9.4505e5
   2 │ api.stu  2.89321e6  8.10919e5

julia> bootclus_two_stage = bootweights(clus_two_stage; replicates=1000);

julia> mean(:api00, :cname, bootclus_two_stage)
26×3 DataFrame
 Row │ cname            mean     SE
     │ String15         Float64  Any
─────┼───────────────────────────────────────
   1 │ Placer           821.0    0.0
   2 │ Tuolumne         773.0    0.0
   3 │ San Mateo        743.091  92.7257
   4 │ San Luis Obispo  811.0    0.0
  ⋮  │        ⋮            ⋮          ⋮
  23 │ Monterey         720.5    6.50969e-15
  24 │ Tulare           607.5    106.359
  25 │ Stanislaus       730.4    3.32051e-14
  26 │ Contra Costa     864.0    0.0
                              18 rows omitted
```

## Future goals

We want to implement all the features provided by the
[Survey package in R](https://cran.r-project.org/web/packages/survey/index.html)
in a Julia-native way. The main goal is to have a complete package that provides
a large range of functionality and takes efficiency into consideration, such that
large surveys can be analysed fast.

The [milestones](https://github.com/xKDR/Survey.jl/milestones) section of the repository
contains a list of features that contributors can implement in the short-term.

## Support

We gratefully acknowledge the JuliaLab at MIT for financial support for this project.
