"""
    total(var, design)

Estimate the population total of variable.

```jldoctest
julia> apiclus1 = load_data("apiclus1");

julia> dclus1 = SurveyDesign(apiclus1; clusters = :dnum, weights = :pw);

julia> total(:api00, dclus1)
1×1 DataFrame
 Row │ total
     │ Float64
─────┼───────────
   1 │ 3.98999e6
```
"""
function total(x::Symbol, design::SurveyDesign)
    X = wsum(design.data[!, x], weights(design.data[!, design.weights]))
    DataFrame(total = X)
end

"""
    total(x::Symbol, design::ReplicateDesign)

Compute the standard error of the estimated total using replicate weights.

# Arguments
- `x::Symbol`: Symbol representing the variable for which the total is estimated.
- `design::ReplicateDesign`: Replicate design object.

# Returns
- `df`: DataFrame containing the estimated total and its standard error.

# Examples

```jldoctest; setup = :(using Survey; apiclus1 = load_data("apiclus1"); dclus1 = SurveyDesign(apiclus1; clusters = :dnum, weights = :pw); bclus1 = dclus1 |> bootweights;)

julia> total(:api00, bclus1)
1×2 DataFrame
 Row │ total      SE
     │ Float64    Float64
─────┼──────────────────────
   1 │ 3.98999e6  9.01611e5
```
"""
function total(x::Symbol, design::ReplicateDesign)

    # Define an inner function to calculate the total
    function inner_total(df::DataFrame, column, weights)
        return StatsBase.wsum(df[!, column], StatsBase.weights(df[!, weights]))
    end

    # Calculate the total and variance
    df = variance(x, inner_total, design)

    rename!(df, :estimator => :total)
    
    return df
end

"""
Estimate the population total of a list of variables.

```jldoctest totallabel; setup = :(apiclus1 = load_data("apiclus1"); dclus1 = SurveyDesign(apiclus1; clusters = :dnum, weights = :pw); bclus1 = dclus1 |> bootweights)
julia> total([:api00, :enroll], dclus1)
2×2 DataFrame
 Row │ names   total
     │ String  Float64
─────┼───────────────────
   1 │ api00   3.98999e6
   2 │ enroll  3.40494e6
``` 

Use replicate weights to compute the standard error of the estimated means. 

```jldoctest totallabel
julia> total([:api00, :enroll], bclus1)
2×3 DataFrame
 Row │ names   total      SE
     │ String  Float64    Float64
─────┼──────────────────────────────
   1 │ api00   3.98999e6  9.01611e5
   2 │ enroll  3.40494e6  9.33396e5 
```
"""
function total(x::Vector{Symbol}, design::AbstractSurveyDesign)
    df = reduce(vcat, [total(i, design) for i in x])
    insertcols!(df, 1, :names => String.(x))
    return df
end

"""
    total(var, domain, design)

Estimate population totals of domains.

```jldoctest totallabel; setup = :(using Survey; apiclus1 = load_data("apiclus1"); dclus1 = SurveyDesign(apiclus1; clusters = :dnum, weights = :pw); bclus1 = dclus1 |> bootweights;)
julia> total(:api00, :cname, dclus1)
11×2 DataFrame
 Row │ total           cname       
     │ Float64         String15    
─────┼─────────────────────────────
   1 │      3.7362e6   Alameda
   2 │      9.58547e5  Fresno
   3 │ 459473.0        Kern
   4 │      2.46465e6  Los Angeles
   5 │      1.26571e6  Mendocino
   6 │      1.0545e6   Merced
   7 │      5.7721e6   Orange
   8 │      3.2422e6   Plumas
   9 │      9.20698e6  San Diego
  10 │      1.03541e7  San Joaquin
  11 │      3.22122e6  Santa Clara
```
Use the replicate design to compute standard errors of the estimated totals. 

```jldoctest totallabel
julia> total(:api00, :cname, bclus1)
11×3 DataFrame
 Row │ total           SE         cname       
     │ Float64         Float64    String15    
─────┼────────────────────────────────────────
   1 │      3.22122e6  2.6143e6   Santa Clara
   2 │      9.20698e6  8.00251e6  San Diego
   3 │      1.0545e6   9.85983e5  Merced
   4 │      2.46465e6  2.15017e6  Los Angeles
   5 │      5.7721e6   5.40929e6  Orange
   6 │      9.58547e5  8.95488e5  Fresno
   7 │      3.2422e6   3.03494e6  Plumas
   8 │      3.7362e6   3.49184e6  Alameda
   9 │      1.03541e7  9.69862e6  San Joaquin
  10 │ 459473.0        4.30027e5  Kern
  11 │      1.26571e6  1.18696e6  Mendocino
```
"""
function total(x::Symbol, domain, design::AbstractSurveyDesign)
    df = bydomain(x, domain, design, total)
    return df
end