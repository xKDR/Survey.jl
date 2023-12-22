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

```jldoctest; setup = :(using Survey, StatsBase; apiclus1 = load_data("apiclus1"); dclus1 = SurveyDesign(apiclus1; clusters = :dnum, weights = :pw); bclus1 = dclus1 |> bootweights)
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

    # Calculate the mean and standard error
    df = Survey.standarderror(x, inner_mean, design)
    
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
     │ Float64  String
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
 Row │ mean     SE            cname
     │ Float64  Float64       String
─────┼────────────────────────────────────
   1 │ 732.077  58.2169       Santa Clara
   2 │ 659.436   2.66703      San Diego
   3 │ 519.25    2.28936e-15  Merced
   4 │ 647.267  47.6233       Los Angeles
   5 │ 710.563   2.19826e-13  Orange
   6 │ 472.0     1.13687e-13  Fresno
   7 │ 709.556   1.26058e-13  Plumas
   8 │ 669.0     1.27527e-13  Alameda
   9 │ 551.189   2.18162e-13  San Joaquin
  10 │ 452.5     0.0          Kern
  11 │ 623.25    1.09545e-13  Mendocino
```
"""
function mean(x::Symbol, domain, design::AbstractSurveyDesign)
    df = bydomain(x, domain, design, mean)
    return df
end