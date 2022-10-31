# Examples

The following examples use the
[Academic Performance Index](https://r-survey.r-forge.r-project.org/survey/html/api.html)
(API) dataset for Californian schools. The data sets contain information for all schools
with at least 100 students and for various probability samples of the data.

The API program has been discontinued at the end of 2018. Information is archived at
[https://www.cde.ca.gov/re/pr/api.asp](https://www.cde.ca.gov/re/pr/api.asp)

## Simple Random Sample

Firstly, a survey design needs a dataset from which to gather information. A dataset
can be loaded as a `DataFrame` using the `load_data` function:

```julia
julia> apisrs = load_data("apisrs");
```

Next, we can build a design. The most basic survey design is a simple random sample design.
A [`SimpleRandomSample`](@ref) can be instantianted by calling the constructor:

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

With a `SimpleRandomSample` (as well as with any subtype of [`AbstractSurveyDesign`](@ref))
it is possible to calculate estimates of the mean or population total for a given variable,
along with the corresponding standard errors.

```julia
julia> svymean(:api00, srs)
1×2 DataFrame
 Row │ mean     sem     
     │ Float64  Float64 
─────┼──────────────────
   1 │ 656.585  9.24972

julia> svytotal(:api00, srs)
1×2 DataFrame
 Row │ total      se_total 
     │ Float64    Float64  
─────┼─────────────────────
   1 │ 4.06689e6   57292.8
```

The design can be tweaked by specifying the population or sample size or whether
or not to account for finite population correction (fpc). By default the weights
are equal to one, the sample size is equal to the number of rows in `data` and the
fpc is not ignored. The population size is calculated from the weights.

When `ignorefpc` is set to `false` the `fpc` is calculated from the sample and population
sizes. When it is set to `true` it is set to 1.
