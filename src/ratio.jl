"""
    ratio(numerator, denominator, design)

Estimate the ratio of the columns specified in numerator and denominator, with
the standard error computed by Taylor linearization (matching `svyratio` in R).

```jldoctest
julia> apiclus1 = load_data("apiclus1");

julia> dclus1 = SurveyDesign(apiclus1; clusters = :dnum, weights = :pw);

julia> ratio([:api00, :enroll], dclus1)
1×2 DataFrame
 Row │ ratio    SE
     │ Float64  Float64
─────┼───────────────────
   1 │ 1.17182  0.127545

```
"""
function ratio(x::Vector{Symbol}, design::SurveyDesign)

    variable_num, variable_den = x[1], x[2]

    se, X = _se_ratio(
        design.data[!, variable_num],
        design.data[!, variable_den],
        design,
    )
    DataFrame(ratio = X, SE = se)
end

"""
    ratio(x::Vector{Symbol}, design::ReplicateDesign)

Compute the standard error of the ratio using replicate weights.

# Arguments
- `variable_num::Symbol`: Symbol representing the numerator variable.
- `variable_den::Symbol`: Symbol representing the denominator variable.
- `design::ReplicateDesign`: Replicate design object.

# Examples

```jldoctest; setup = :(using Survey, StatsBase; apiclus1 = load_data("apiclus1"); dclus1 = SurveyDesign(apiclus1; clusters = :dnum, weights = :pw); bclus1 = bootweights(dclus1);)
julia> ratio([:api00, :api99], bclus1)
1×2 DataFrame
 Row │ estimator  SE
     │ Float64    Float64
─────┼───────────────────────
   1 │   1.06127  0.00685453
```
"""
function ratio(x::Vector{Symbol}, design::ReplicateDesign)
    
    variable_num, variable_den = x[1], x[2]

    # Define an inner function to calculate the ratio
    function inner_ratio(df::DataFrame, columns, weights_column)
        return sum(df[!, columns[1]], StatsBase.weights(df[!, weights_column])) / sum(df[!, columns[2]], StatsBase.weights(df[!, weights_column]))
    end

    # Calculate the standard error using the `standarderror` function with the inner function
    return standarderror([variable_num, variable_den], inner_ratio, design)
end

"""
    ratio(var, domain, design)

Estimate ratios of domains.

```jldoctest ratiolabel; setup = :(using Survey, StatsBase; apiclus1 = load_data("apiclus1"); dclus1 = SurveyDesign(apiclus1; clusters = :dnum, weights = :pw); bclus1 = dclus1 |> bootweights)
julia> ratio([:api00, :api99], :cname, dclus1)
11×3 DataFrame
 Row │ ratio    SE           cname
     │ Float64  Float64      String
─────┼───────────────────────────────────
   1 │ 1.09852  1.01915e-16  Alameda
   2 │ 1.17779  2.42861e-16  Fresno
   3 │ 1.11453  0.0          Kern
   4 │ 1.06307  0.00780246   Los Angeles
   5 │ 1.00565  4.68375e-17  Mendocino
   6 │ 1.08121  8.32667e-17  Merced
   7 │ 1.03628  2.48391e-16  Orange
   8 │ 1.02127  7.28584e-17  Plumas
   9 │ 1.06112  0.00842564   San Diego
  10 │ 1.07331  1.61763e-16  San Joaquin
  11 │ 1.05598  0.0137928    Santa Clara
```

Use the replicate design to compute standard errors of the estimated means. 

```jldoctest ratiolabel
julia> ratio([:api00, :api99], :cname, bclus1)
11×3 DataFrame
 Row │ estimator  SE           cname
     │ Float64    Float64      String
─────┼─────────────────────────────────────
   1 │   1.05598  0.0191326    Santa Clara
   2 │   1.06112  0.00969399   San Diego
   3 │   1.08121  6.47299e-17  Merced
   4 │   1.06307  0.0257811    Los Angeles
   5 │   1.03628  0.0          Orange
   6 │   1.17779  7.76836e-18  Fresno
   7 │   1.02127  0.0          Plumas
   8 │   1.09852  2.12491e-16  Alameda
   9 │   1.07331  2.22045e-16  San Joaquin
  10 │   1.11453  0.0          Kern
  11 │   1.00565  0.0          Mendocino
```
"""
function ratio(x::Vector{Symbol}, domain, design::AbstractSurveyDesign)
    df = bydomain(x, domain, design, ratio)
    return df
end
