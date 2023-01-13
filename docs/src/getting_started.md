## Instalation

The `Survey.jl` package is not yet registered. For now, installation of the package
is done using the following command:

```julia
]  add "https://github.com/xKDR/Survey.jl.git"
```

After registration, the regular `Pkg` commands can be used for installing the package:

```julia
julia> using Pkg

julia> Pkg.add("Survey")
```

```julia
julia> ]  add Survey
```

## Tutorial

This tutorial assumes basic knowledge of statistics and survey analysis.

To begin this tutorial, load the package in your workspace:

```julia
julia> using Survey
```

Now load a survey dataset that you want to study. In this tutorial we will be using
the [Academic Performance Index](https://r-survey.r-forge.r-project.org/survey/html/api.html)
(API) datasets for Californian schools. The datasets contain information for all
schools with at least 100 students and for various probability samples of the
data.

!!! note

    The API program has been discontinued at the end of 2018. Information is archived
    at [https://www.cde.ca.gov/re/pr/api.asp](https://www.cde.ca.gov/re/pr/api.asp)

```julia
julia> apisrs = load_data("apisrs")
200×40 DataFrame
 Row │ Column1  cds             stype    name             sname                          snum   dn ⋯
     │ Int64    Int64           String1  String15         String                         Int64  St ⋯
─────┼──────────────────────────────────────────────────────────────────────────────────────────────
   1 │    1039  15739081534155  H        McFarland High   McFarland High                  1039  Mc ⋯
   2 │    1124  19642126066716  E        Stowers (Cecil   Stowers (Cecil B.) Elementary   1124  AB
   3 │    2868  30664493030640  H        Brea-Olinda Hig  Brea-Olinda High                2868  Br
   4 │    1273  19644516012744  E        Alameda Element  Alameda Elementary              1273  Do
   5 │    4926  40688096043293  E        Sunnyside Eleme  Sunnyside Elementary            4926  Sa ⋯
   6 │    2463  19734456014278  E        Los Molinos Ele  Los Molinos Elementary          2463  Ha
  ⋮  │    ⋮           ⋮            ⋮            ⋮                       ⋮                  ⋮       ⋱
 196 │     969  15635291534775  H        North High       North High                       969  Ke
 197 │    1752  19647336017446  E        Hammel Street E  Hammel Street Elementary        1752  Lo
 198 │    4480  37683386039143  E        Audubon Element  Audubon Elementary              4480  Sa ⋯
 199 │    4062  36678196036222  E        Edison Elementa  Edison Elementary               4062  On
 200 │    2683  24657716025621  E        Franklin Elemen  Franklin Elementary             2683  Me
                                                                     34 columns and 189 rows omitted
```

`apisrs` is a simple random sample of the Academic Performance Index of Californian
schools. The [`load_data`](@ref) function loads it as a
[`DataFrame`](https://dataframes.juliadata.org/stable/lib/types/#DataFrames.DataFrame).
You can look at the column names of `apisrs` to get an idea of what the dataset
contains.

```julia
julia> names(apisrs)
40-element Vector{String}:
 "Column1"
 "cds"
 "stype"
 "name"
 "sname"
 "snum"
 "dname"
 "dnum"
 ⋮
 "avg.ed"
 "full"
 "emer"
 "enroll"
 "api.stu"
 "pw"
 "fpc"
```

Next, build a survey design from your `DataFrame`:

```julia
julia> srs = SurveyDesign(apisrs; weights=:pw)
SurveyDesign:
data: 200×47 DataFrame
strata: none
cluster: none
popsize: [6190.0, 6190.0, 6190.0  …  6190.0]
sampsize: [200, 200, 200  …  200]
weights: [31.0, 31.0, 31.0  …  31.0]
probs: [0.0323, 0.0323, 0.0323  …  0.0323]
```

This is a simple random sample design with weights given by the column `:pw` of
`apisrs`. You can also create more complex designs such as stratified or cluster
sample designs. You can find more information on the complete capabilities of
the package in the [Manual](@ref). The purpose of this tutorial is to show the
basic usage of the package. For that, we will stick with a simple random sample.

Now you can analyse your design according to your needs using the
[functionality](@ref Index) provided by the package.
