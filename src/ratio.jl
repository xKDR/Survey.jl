"""
    ratio(numerator, denominator, design)

Estimate the ratio of the columns specified in numerator and denominator.

```jldoctest
julia> apiclus1 = load_data("apiclus1");

julia> dclus1 = SurveyDesign(apiclus1; clusters = :dnum, weights = :pw);

julia> ratio(:api00, :enroll, dclus1)
1×1 DataFrame
 Row │ ratio
     │ Float64
─────┼─────────
   1 │ 1.17182

```
"""
function ratio(x::Vector{Symbol}, design::SurveyDesign)

    variable_num, variable_den = x[1], x[2]
    
    X =
        wsum(design.data[!, variable_num], design.data[!, design.weights]) /
        wsum(design.data[!, variable_den], design.data[!, design.weights])
    DataFrame(ratio = X)
end

"""
    ratio(x::Vector{Symbol}, design::ReplicateDesign)

Compute the standard error of the ratio using replicate weights.

# Arguments
- `variable_num::Symbol`: Symbol representing the numerator variable.
- `variable_den::Symbol`: Symbol representing the denominator variable.
- `design::ReplicateDesign`: Replicate design object.

# Returns
- `var`: Variance of the ratio.

# Examples

```jldoctest; setup = :(using Survey, StatsBase; apiclus1 = load_data("apiclus1"); dclus1 = SurveyDesign(apiclus1; clusters = :dnum, weights = :pw); bclus1 = bootweights(dclus1);)

julia> ratio([:api00, :api99], bclus1)
1×2 DataFrame
 Row │ estimator  SE         
     │ Float64    Float64    
─────┼───────────────────────
   1 │   1.06127  0.00672259
```
"""
function ratio(x::Vector{Symbol}, design::ReplicateDesign)
    
    variable_num, variable_den = x[1], x[2]

    # Define an inner function to calculate the ratio
    function inner_ratio(df::DataFrame, columns, weights_column)
        return sum(df[!, columns[1]], StatsBase.weights(df[!, weights_column])) / sum(df[!, columns[2]], StatsBase.weights(df[!, weights_column]))
    end

    # Calculate the variance using the `variance` function with the inner function
    var = variance([variable_num, variable_den], inner_ratio, design)
    return var
end

"""
    ratio(var, domain, design)

Estimate ratios of domains.

```jldoctest ratiolabel; setup = :(using Survey, StatsBase; apiclus1 = load_data("apiclus1"); dclus1 = SurveyDesign(apiclus1; clusters = :dnum, weights = :pw); bclus1 = dclus1 |> bootweights;)
julia> ratio([:api00, :api99], :cname, dclus1)
11×2 DataFrame
 Row │ ratio    cname       
     │ Float64  String15    
─────┼──────────────────────
   1 │ 1.09852  Alameda
   2 │ 1.17779  Fresno
   3 │ 1.11453  Kern
   4 │ 1.06307  Los Angeles
   5 │ 1.00565  Mendocino
   6 │ 1.08121  Merced
   7 │ 1.03628  Orange
   8 │ 1.02127  Plumas
   9 │ 1.06112  San Diego
  10 │ 1.07331  San Joaquin
  11 │ 1.05598  Santa Clara
```

Use the replicate design to compute standard errors of the estimated means. 

```jldoctest ratiolabel
julia> ratio([:api00, :api99], :cname, bclus1)
11×3 DataFrame
 Row │ estimator  SE       cname       
     │ Float64    Float64  String15    
─────┼─────────────────────────────────
   1 │   1.05598      NaN  Santa Clara
   2 │   1.06112      NaN  San Diego
   3 │   1.08121      NaN  Merced
   4 │   1.06307      NaN  Los Angeles
   5 │   1.03628      NaN  Orange
   6 │   1.17779      NaN  Fresno
   7 │   1.02127      NaN  Plumas
   8 │   1.09852      NaN  Alameda
   9 │   1.07331      NaN  San Joaquin
  10 │   1.11453      NaN  Kern
  11 │   1.00565      NaN  Mendocino
```
"""
function ratio(x::Vector{Symbol}, domain, design::AbstractSurveyDesign)
    df = bydomain(x, domain, design, ratio)
    return df
end