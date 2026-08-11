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
julia> ratio([:api00, :api99], :stype, dclus1)
3×3 DataFrame
 Row │ ratio    SE          stype
     │ Float64  Float64     String
─────┼─────────────────────────────
   1 │ 1.03837  0.0114577   H
   2 │ 1.06758  0.00713347  E
   3 │ 1.03753  0.0104412   M
```

Use the replicate design to compute standard errors of the estimated ratios.

```jldoctest ratiolabel
julia> ratio([:api00, :api99], :stype, bclus1)
3×3 DataFrame
 Row │ estimator  SE          stype
     │ Float64    Float64     String
─────┼───────────────────────────────
   1 │   1.06758  0.00776773  E
   2 │   1.03753  0.0112329   M
   3 │   1.03837  0.014136    H
```
"""
function ratio(x::Vector{Symbol}, domain, design::AbstractSurveyDesign)
    df = bydomain(x, domain, design, ratio)
    return df
end
