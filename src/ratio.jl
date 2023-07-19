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
function ratio(variable_num::Symbol, variable_den::Symbol, design::SurveyDesign)
    X =
        wsum(design.data[!, variable_num], design.data[!, design.weights]) /
        wsum(design.data[!, variable_den], design.data[!, design.weights])
    DataFrame(ratio = X)
end

"""
    ratio(variable_num::Symbol, variable_den::Symbol, design::ReplicateDesign)

Compute the standard error of the ratio using replicate weights.

# Arguments
- `variable_num::Symbol`: Symbol representing the numerator variable.
- `variable_den::Symbol`: Symbol representing the denominator variable.
- `design::ReplicateDesign`: Replicate design object.

# Returns
- `var`: Variance of the ratio.

# Examples

```jldoctest; setup = :(using Survey, StatsBase; apiclus1 = load_data("apiclus1"); dclus1 = SurveyDesign(apiclus1; clusters = :dnum, weights = :pw); bclus1 = bootweights(dclus1);)

julia> ratio(:api00, :enroll, bclus1)
1×2 DataFrame
 Row │ estimator  SE
     │ Float64    Float64
─────┼─────────────────────
   1 │   1.17182  0.131518
```
"""
function ratio(variable_num::Symbol, variable_den::Symbol, design::ReplicateDesign)
    
    # Define an inner function to calculate the ratio
    function compute_ratio(df::DataFrame, columns, weights_column)
        return sum(df[!, columns[1]], StatsBase.weights(df[!, weights_column])) / sum(df[!, columns[2]], StatsBase.weights(df[!, weights_column]))
    end

    # Calculate the variance using the `variance` function with the inner function
    var = variance([variable_num, variable_den], compute_ratio, design)
    return var
end