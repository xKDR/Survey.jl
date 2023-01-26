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
data: 200×45 DataFrame
strata: none
cluster: none
popsize: [6194.0, 6194.0, 6194.0  …  6194.0]
sampsize: [200, 200, 200  …  200]
weights: [30.97, 30.97, 30.97  …  30.97]
allprobs: [0.0323, 0.0323, 0.0323  …  0.0323]
```

This is a simple random sample design with weights given by the column `:pw` of
`apisrs`. You can also create more complex designs such as stratified or cluster
sample designs. You can find more information on the complete capabilities of
the package in the [Manual](@ref). The purpose of this tutorial is to show the
basic usage of the package. For that, we will stick with a simple random sample.

Now you can analyse your design according to your needs using the
[functionality](@ref Index) provided by the package. For example, you can compute
the estimated mean or population total for a given variable. Let's say we're
interested in the mean Academic Performance Index from the year 1999. First we
need to convert the [`SurveyDesign`](@ref) to a [`ReplicateDesign`](@ref) using
bootstrapping:

```julia
julia> bsrs = bootweights(srs)
ReplicateDesign:
data: 200×4045 DataFrame
strata: none
cluster: none
popsize: [6194.0, 6194.0, 6194.0  …  6194.0]
sampsize: [200, 200, 200  …  200]
weights: [30.97, 30.97, 30.97  …  30.97]
allprobs: [0.0323, 0.0323, 0.0323  …  0.0323]
replicates: 4000
```

We do this because [TODO: explain why]. Now we can compute the estimated mean:

```julia
julia> mean(:api99, bsrs)
1×2 DataFrame
 Row │ mean     SE
     │ Float64  Float64
─────┼──────────────────
   1 │ 624.685   9.5747
```

We can also find the mean of both the 1999 API and 2000 API for a clear
comparison between students' performance from one year to another:

```julia
2×3 DataFrame
 Row │ names   mean     SE
     │ String  Float64  Float64
─────┼──────────────────────────
   1 │ api99   624.685  9.5747
   2 │ api00   656.585  9.30656
```

The [`ratio`](@ref) is also appropriate for studying the relationship between
the two APIs:

```julia
julia> ratio(:api00, :api99, bsrs)
1×2 DataFrame
 Row │ ratio    SE
     │ Float64  Float64
─────┼─────────────────────
   1 │ 1.05107  0.00364165
```

If we're interested in a certain statistic estimated by a specific domain, we
can add the domain as the second parameter to our function. Let's say we want
to find the estimated total number of students enrolled in schools from each
county:

```julia
julia> total(:enroll, :cname, bsrs)
38×3 DataFrame
 Row │ cname            total           SE
     │ String15         Float64         Any
─────┼────────────────────────────────────────────
   1 │ Kern                  1.95823e5  74984.5
   2 │ Los Angeles      867129.0        1.34517e5
   3 │ Orange                1.68786e5  63990.2
   4 │ San Luis Obispo    6720.49       6731.29
   5 │ San Francisco     30319.6        18024.1
   6 │ Modoc              6503.7        6500.84
  ⋮  │        ⋮               ⋮             ⋮
  34 │ Yolo              12171.2        12131.8
  35 │ Calaveras         12976.4        13095.7
  36 │ Napa              39239.0        29841.1
  37 │ Lake               6410.79       6562.72
  38 │ Merced            15392.1        14921.9
                                   27 rows omitted
```

Another way to visualize data is through graphs. We can make a histogram to
better see the distribution of enrolled students:

```@setup warning
# !!!THIS NEEDS TO MATCH THE EXAMPLE IN THE DOCSTRING OF `hist`
```

```julia
julia> hist(srs, :enroll)
```

![](assets/hist.png)
