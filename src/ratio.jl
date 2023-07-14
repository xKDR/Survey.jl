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
Use replicate weights to compute the standard error of the ratio.

```jldoctest; setup = :(apiclus1 = load_data("apiclus1"); dclus1 = SurveyDesign(apiclus1; clusters = :dnum, weights = :pw))
julia> bclus1 = bootweights(dclus1); 

julia> ratio(:api00, :enroll, bclus1)
1×2 DataFrame
 Row │ ratio    SE
     │ Float64  Float64
─────┼───────────────────
   1 │ 1.17182  0.131518

```
"""
function ratio(variable_num::Symbol, variable_den::Symbol, design::ReplicateDesign)
    function ratio(df::DataFrame, columns, weights)
        return sum(df[!, columns[1]], StatsBase.weights(df[!, weights])) / sum(df[!, columns[2]], StatsBase.weights(df[!, weights]))
    end

    variance = variance([variable_num, variable_den], ratio, design)
    X = ratio(design.data, [variable_num, variable_den], design.weights)
    DataFrame(ratio = X, SE = sqrt(variance))
end

function ratio(df::DataFrame, columns, weights)
    return sum(df[!, columns[1]], StatsBase.weights(df[!, weights])) / sum(df[!, columns[2]], StatsBase.weights(df[!, weights]))
end