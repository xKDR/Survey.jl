"""
    mean(var, design)

Estimate the mean of a variable, with the standard error computed by Taylor
linearization (the default variance method of the R `survey` package). When the
design was constructed with an explicit `popsize`, a finite population correction
is applied, as in R.

If `var` is a categorical variable (e.g. a vector of strings or a
`CategoricalArray`), the estimated proportion of each level is returned, matching
`svymean` on a factor in R.

```jldoctest meandoc; setup = :(using Survey)
julia> apiclus1 = load_data("apiclus1");

julia> dclus1 = SurveyDesign(apiclus1; clusters = :dnum, weights = :pw);

julia> mean(:api00, dclus1)
1×2 DataFrame
 Row │ mean     SE
     │ Float64  Float64
─────┼──────────────────
   1 │ 644.169   23.779
```

Proportions of a categorical variable:

```jldoctest meandoc
julia> mean(:stype, dclus1)
3×3 DataFrame
 Row │ level    mean       SE
     │ String1  Float64    Float64
─────┼───────────────────────────────
   1 │ E        0.786885   0.0468026
   2 │ H        0.0765027  0.0270799
   3 │ M        0.136612   0.0299472
```
"""
function mean(x::Symbol, design::SurveyDesign)
    col = design.data[!, x]
    if _iscategorical(col)
        levels, props, ses = _category_means(col, design)
        return DataFrame(level = levels, mean = props, SE = ses)
    end
    se, μ = _se_mean(col, design)
    DataFrame(mean = μ, SE = se)
end

# proportions of each level of a categorical variable with linearized SEs
function _category_means(col::AbstractVector, design::SurveyDesign)
    levels = sort!(unique(col))
    props = Float64[]
    ses = Float64[]
    for level in levels
        indicator = Float64.(col .== level)
        se, p = _se_mean(indicator, design)
        push!(props, p)
        push!(ses, se)
    end
    return string.(levels), props, ses
end

"""
	mean(x::Symbol, design::ReplicateDesign)

Compute the standard error of the estimated mean using replicate weights. For a
categorical variable, proportions of each level are estimated.

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
   1 │ 644.169  23.7845
```
"""
function mean(x::Symbol, design::ReplicateDesign)

    if _iscategorical(design.data[!, x])
        levels = sort!(unique(design.data[!, x]))

        # proportion of each level, computed for the full sample and each replicate
        function inner_props(df::DataFrame, column, weights_column)
            w = StatsBase.weights(df[!, weights_column])
            return [StatsBase.mean(Float64.(df[!, column] .== level), w) for level in levels]
        end

        df = Survey.standarderror(x, inner_props, design)
        rename!(df, :estimator => :mean)
        insertcols!(df, 1, :level => string.(levels))
        return df
    end

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
2×3 DataFrame
 Row │ names   mean     SE
     │ String  Float64  Float64
─────┼──────────────────────────
   1 │ api00   644.169  23.779
   2 │ enroll  549.716  45.6459
```

Use replicate weights to compute the standard error of the estimated means.

```jldoctest meanlabel
julia> mean([:api00, :enroll], bclus1)
2×3 DataFrame
 Row │ names   mean     SE
     │ String  Float64  Float64
─────┼──────────────────────────
   1 │ api00   644.169  23.7845
   2 │ enroll  549.716  46.1573
```
"""
function mean(x::Vector{Symbol}, design::AbstractSurveyDesign)
    df = reduce(vcat, [mean(i, design) for i in x])
    insertcols!(df, 1, :names => String.(x))
    return df
end

"""
    mean(var, domain, design)

Estimate means of domains. For a `SurveyDesign`, standard errors are computed by
Taylor linearization using the full design structure, matching `svyby` with
`svymean` in R.

```jldoctest meanlabel; setup = :(apiclus1 = load_data("apiclus1"); dclus1 = SurveyDesign(apiclus1; clusters = :dnum, weights = :pw); bclus1 = dclus1 |> bootweights)
julia> mean(:api00, :cname, dclus1)
11×3 DataFrame
 Row │ mean     SE            cname
     │ Float64  Float64       String
─────┼────────────────────────────────────
   1 │ 669.0     1.14363e-13  Alameda
   2 │ 472.0     0.0          Fresno
   3 │ 452.5     0.0          Kern
   4 │ 647.267  17.4231       Los Angeles
   5 │ 623.25    0.0          Mendocino
   6 │ 519.25    0.0          Merced
   7 │ 710.563   1.13687e-13  Orange
   8 │ 709.556   1.28786e-14  Plumas
   9 │ 659.436   2.3199       San Diego
  10 │ 551.189   1.40332e-13  San Joaquin
  11 │ 732.077  15.9316       Santa Clara
```
Use the replicate design to compute standard errors of the estimated means.

```jldoctest meanlabel
julia> mean(:api00, :cname, bclus1)
11×3 DataFrame
 Row │ mean     SE            cname
     │ Float64  Float64       String
─────┼────────────────────────────────────
   1 │ 732.077  59.7332       Santa Clara
   2 │ 659.436   2.6411       San Diego
   3 │ 519.25    5.92519e-15  Merced
   4 │ 647.267  47.7412       Los Angeles
   5 │ 710.563   2.17725e-13  Orange
   6 │ 472.0     1.13687e-13  Fresno
   7 │ 709.556   1.27381e-13  Plumas
   8 │ 669.0     1.27844e-13  Alameda
   9 │ 551.189   2.17352e-13  San Joaquin
  10 │ 452.5     0.0          Kern
  11 │ 623.25    1.08494e-13  Mendocino
```
"""
function mean(x::Symbol, domain, design::AbstractSurveyDesign)
    df = bydomain(x, domain, design, mean)
    return df
end
