```@meta
CurrentModule = Survey
```

# Survey

This package is used to study complex survey data. It aims to be a fast alternative to the [Survey package in R](https://cran.r-project.org/web/packages/survey/index.html) developed by [Professor Thomas Lumley](https://www.stat.auckland.ac.nz/people/tlum005).

This package currently supports simple random sample and stratified sample. In future releases, it will support multistage sampling as well. 

## Basic demo

The following demo uses the
[Academic Performance Index](https://r-survey.r-forge.r-project.org/survey/html/api.html)
(API) dataset for Californian schools. The data sets contain information for all schools
with at least 100 students and for various probability samples of the data.

The API program has been discontinued at the end of 2018. Information is archived at
[https://www.cde.ca.gov/re/pr/api.asp](https://www.cde.ca.gov/re/pr/api.asp)

Firstly, a survey design needs a dataset from which to gather information. The sample
datasets provided with the package can be loaded as `DataFrame`s using [`load_data`](@ref):

```julia
julia> apisrs = load_data("apisrs");
```

`apisrs` is a simple random sample of the Academic Performance Index of Californian schools.

Next, we can build a design.
#TODO: continue tutorial
