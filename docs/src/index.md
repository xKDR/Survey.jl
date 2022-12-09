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

Firstly, a survey design needs a dataset from which to gather information. 


The sample datasets provided with the package can be loaded as `DataFrames` using the `load_data` function:

```julia
julia> apisrs = load_data("apisrs");
```
`apisrs` is a simple random sample of the Academic Performance Index of Californian schools.

Next, we can build a design. The design corresponding to a simple random sample is [`SimpleRandomSample`](@ref), which can be instantiated by calling the constructor:

```julia
julia> srs = SimpleRandomSample(apisrs; weights = :pw)
SimpleRandomSample:
data: 200x42 DataFrame
weights: 31.0, 31.0, 31.0, ..., 31.0
probs: 0.0323, 0.0323, 0.0323, ..., 0.0323
fpc: 6194, 6194, 6194, ..., 6194
popsize: 6194
sampsize: 200
sampfraction: 0.0323
ignorefpc: false
```

With a `SimpleRandomSample` (as well as with any subtype of [`AbstractSurveyDesign`](@ref)) it is possible to calculate estimates of the mean, population total, etc., for a given variable, along with the corresponding standard errors.

```julia
julia> mean(:api00, srs)
1×2 DataFrame
 Row │ mean     sem     
     │ Float64  Float64 
─────┼──────────────────
   1 │ 656.585  9.24972

julia> total(:api00, srs)
1×2 DataFrame
 Row │ total      se_total 
     │ Float64    Float64  
─────┼─────────────────────
   1 │ 4.06689e6   57292.8
```
