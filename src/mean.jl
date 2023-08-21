"""
    mean(var, design)

Estimate the mean of a variable.

```jldoctest
julia> apiclus1 = load_data("apiclus1");

julia> dclus1 = SurveyDesign(apiclus1; clusters = :dnum, weights = :pw)
SurveyDesign:
data: 183×44 DataFrame
strata: none
cluster: dnum
    [637, 637, 637  …  448]
popsize: [507.7049, 507.7049, 507.7049  …  507.7049]
sampsize: [15, 15, 15  …  15]
weights: [33.847, 33.847, 33.847  …  33.847]
allprobs: [0.0295, 0.0295, 0.0295  …  0.0295]

julia> mean(:api00, dclus1)
1×1 DataFrame
 Row │ mean
     │ Float64
─────┼─────────
   1 │ 644.169 
```
"""
function mean(x::Symbol, design::SurveyDesign)
    X = mean(design.data[!, x], weights(design.data[!, design.weights]))
    DataFrame(mean = X)
end

"""
	mean(x::Symbol, design::ReplicateDesign)

Compute the standard error of the estimated mean using replicate weights.

# Arguments
- `x::Symbol`: Symbol representing the variable for which the mean is estimated.
- `design::ReplicateDesign`: Replicate design object.

# Returns
- `df`: DataFrame containing the estimated mean and its standard error.

# Examples

```jldoctest; setup = :(using Survey, StatsBase; apiclus1 = load_data("apiclus1"); dclus1 = SurveyDesign(apiclus1; clusters = :dnum, weights = :pw); bclus1 = dclus1 |> bootweights;)

julia> mean(:api00, bclus1)
1×2 DataFrame
 Row │ mean     SE
     │ Float64  Float64
─────┼──────────────────
   1 │ 644.169  23.4107
```
"""
function mean(x::Symbol, design::ReplicateDesign)
    
    # Define an inner function to calculate the mean
    function inner_mean(df::DataFrame, column, weights_column)
        return StatsBase.mean(df[!, column], StatsBase.weights(df[!, weights_column]))
    end

    # Calculate the mean and variance
    df = Survey.variance(x, inner_mean, design)
    
    rename!(df, :estimator => :mean)
    
    return df
end

"""
Estimate the mean of a list of variables.

```jldoctest meanlabel; setup = :(using Survey, StatsBase; apiclus1 = load_data("apiclus1"); dclus1 = SurveyDesign(apiclus1; clusters = :dnum, weights = :pw); bclus1 = dclus1 |> bootweights)
julia> mean([:api00, :enroll], dclus1)
2×2 DataFrame
 Row │ names   mean
     │ String  Float64
─────┼─────────────────
   1 │ api00   644.169
   2 │ enroll  549.716
``` 

Use replicate weights to compute the standard error of the estimated means. 

```jldoctest meanlabel
julia> mean([:api00, :enroll], bclus1)
2×3 DataFrame
 Row │ names   mean     SE
     │ String  Float64  Float64
─────┼──────────────────────────
   1 │ api00   644.169  23.4107
   2 │ enroll  549.716  45.7835 
```
"""
function mean(x::Vector{Symbol}, design::AbstractSurveyDesign)
    df = reduce(vcat, [mean(i, design) for i in x])
    insertcols!(df, 1, :names => String.(x))
    return df
end

"""
    mean(var, domain, design)

Estimate means of domains.

```jldoctest meanlabel; setup = :(apiclus1 = load_data("apiclus1"); dclus1 = SurveyDesign(apiclus1; clusters = :dnum, weights = :pw); bclus1 = dclus1 |> bootweights)
julia> mean(:api00, :cname, dclus1)
11×2 DataFrame
 Row │ mean     cname       
     │ Float64  String15    
─────┼──────────────────────
   1 │ 669.0    Alameda
   2 │ 472.0    Fresno
   3 │ 452.5    Kern
   4 │ 647.267  Los Angeles
   5 │ 623.25   Mendocino
   6 │ 519.25   Merced
   7 │ 710.563  Orange
   8 │ 709.556  Plumas
   9 │ 659.436  San Diego
  10 │ 551.189  San Joaquin
  11 │ 732.077  Santa Clara
```
Use the replicate design to compute standard errors of the estimated means. 

```jldoctest meanlabel
julia> mean(:api00, :cname, bclus1)
11×3 DataFrame
 Row │ mean     SE       cname       
     │ Float64  Float64  String15    
─────┼───────────────────────────────
   1 │ 732.077      NaN  Santa Clara
   2 │ 659.436      NaN  San Diego
   3 │ 519.25       NaN  Merced
   4 │ 647.267      NaN  Los Angeles
   5 │ 710.563      NaN  Orange
   6 │ 472.0        NaN  Fresno
   7 │ 709.556      NaN  Plumas
   8 │ 669.0        NaN  Alameda
   9 │ 551.189      NaN  San Joaquin
  10 │ 452.5        NaN  Kern
  11 │ 623.25       NaN  Mendocino
```
"""
function mean(x::Symbol, domain, design::AbstractSurveyDesign)
    df = bydomain(x, domain, design, mean)
    return df
end