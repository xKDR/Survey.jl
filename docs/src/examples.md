# Examples

The following examples use the
[Academic Performance Index](https://r-survey.r-forge.r-project.org/survey/html/api.html)
(API) dataset for Californian schools. The data sets contain information for all schools
with at least 100 students and for various probability samples of the data.

Details about the columns of the dataset can be found here:
https://r-survey.r-forge.r-project.org/survey/html/api.html

The API program has been discontinued at the end of 2018. Information is archived at
https://www.cde.ca.gov/re/pr/api.asp

## Simple Random Sample

Firstly, a survey design needs a dataset from which to gather information. A dataset
can be loaded as a `DataFrame` using the `load_data` function:

```julia
julia> apisrs = load_data("apisrs");
```

Next, we can build a design. The most basic survey design is a simple random sample design.
A [`SimpleRandomSample`](@ref) can be instantianted by calling the constructor:

```julia
julia> srs = SimpleRandomSample(apisrs)
Simple Random Sample:
data: 200x42 DataFrame
probs: 1.0, 1.0, 1.0 ... 1.0
fpc: 1
    popsize: 200
    sampsize: 200
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
   1 │ 656.585  9.40277

julia> svytotal(:api00, srs)
1×2 DataFrame
 Row │ total     se_total
     │ Float64   Float64
─────┼────────────────────
   1 │ 131317.0   1880.55
```

The complexity of the design can be increased by specifying frequency or probability
weights, the population or sample size and whether or not to account for finite
population correction (fpc). By default the weights are equal to one, the sample size is
equal to the number of rows in `data` the fpc is ignored. The population size is calculated
from the weights.

```julia
julia> wsrs = SimpleRandomSample(apisrs; weights = :pw)
Simple Random Sample:
data: 200x42 DataFrame
weights: 31.0, 31.0, 31.0 ... 31.0
probs: 0.0323, 0.0323, 0.0323 ... 0.0323
fpc: 1
    popsize: 6194
    sampsize: 200

julia> fpcwsrs = SimpleRandomSample(apisrs; weights = :pw, ignorefpc = false)
Simple Random Sample:
data: 200x42 DataFrame
weights: 31.0, 31.0, 31.0 ... 31.0
probs: 0.0323, 0.0323, 0.0323 ... 0.0323
fpc: 0.968
    popsize: 6194
    sampsize: 200
```

When `ignorefpc` is set to `false` the `fpc` is calculated from the sample and population
sizes.

The statistics for mean and population total are different when the design takes weights
and fpc into account:

```julia
julia> svymean(:api00, fpcwsrs)
1×2 DataFrame
 Row │ mean     sem
     │ Float64  Float64
─────┼──────────────────
   1 │ 656.585  9.24972

julia> svytotal(:api00, fpcwsrs)
1×2 DataFrame
 Row │ total      se_total
     │ Float64    Float64
─────┼─────────────────────
   1 │ 4.06689e6   57292.8
```
