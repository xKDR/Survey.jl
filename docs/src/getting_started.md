## Installation

The `Survey.jl` package is registered. Regular `Pkg` commands can be used for installing the package:

```@repl
using Pkg

Pkg.add("Survey")
```

```julia
]  add Survey
```

## Tutorial

This tutorial assumes basic knowledge of statistics and survey analysis.

To begin this tutorial, load the package in your workspace:

```@repl tutorial
using Survey
```

Now load a survey dataset that you want to study. In this tutorial we will be using
the [Academic Performance Index](https://r-survey.r-forge.r-project.org/survey/html/api.html)
(API) datasets for Californian schools. The datasets contain information for all
schools with at least 100 students and for various probability samples of the
data.

```@repl tutorial
apisrs = load_data("apisrs")
```

`apisrs` is a simple random sample of the Academic Performance Index of Californian
schools. The [`load_data`](@ref) function loads it as a
[`DataFrame`](https://dataframes.juliadata.org/stable/lib/types/#DataFrames.DataFrame).
You can look at the column names of `apisrs` to get an idea of what the dataset
contains.

```@repl tutorial
names(apisrs)
```

Next, build a survey design from your `DataFrame`:

```@repl tutorial
srs = SurveyDesign(apisrs; weights=:pw)
```

This is a simple random sample design with weights given by the column `:pw` of
`apisrs`. You can also create more complex designs such as stratified or cluster
sample designs. You can find more information on the complete capabilities of
the package in the [Manual](@ref manual). The purpose of this tutorial is to show the
basic usage of the package. For that, we will stick with a simple random sample.

Now you can analyse your design according to your needs using the
[functionality](@ref Index) provided by the package. For example, you can compute
the estimated mean or population total for a given variable. Let's say you want
to find the mean Academic Performance Index from the year 1999. If you are only
interested in the estimated mean, then you can directly pass your design to the
[`mean`](@ref) function:

```@repl tutorial
mean(:api99, srs)
```

If you also want to know the standard error of the mean, you need to convert the
[`SurveyDesign`](@ref) to a [`ReplicateDesign`](@ref) using bootstrapping:

```@repl tutorial
bsrs = bootweights(srs; replicates = 1000)
mean(:api99, bsrs)
```

You can find the mean of both the 1999 API and 2000 API for a clear comparison
between students' performance from one year to another:

```@repl tutorial
mean([:api99, :api00], bsrs)
```

The [`ratio`](@ref) is also appropriate for studying the relationship between
the two APIs:

```@repl tutorial
ratio(:api00, :api99, bsrs)
```

If you're interested in a certain statistic estimated by a specific domain, you
can add the domain as the second parameter to your function. Let's say you want
to find the estimated total number of students enrolled in schools from each
county:

```@repl tutorial
total(:enroll, :cname, bsrs)
```

Another way to visualize data is through graphs. You can make a histogram to
better see the distribution of enrolled students:

```@setup warning
# !!!THIS NEEDS TO MATCH THE EXAMPLE IN THE DOCSTRING OF `hist`
```

```julia
julia> hist(srs, :enroll)
```

The REPL doesn't show the plot. To see it, you need to save it locally.

```julia
julia> import AlgebraOfGraphics.save

julia> save("hist.png", h)
```

![](assets/hist.png)
