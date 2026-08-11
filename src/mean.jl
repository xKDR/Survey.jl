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
julia> mean(:api00, :stype, dclus1)
3×3 DataFrame
 Row │ mean     SE       stype
     │ Float64  Float64  String
─────┼──────────────────────────
   1 │ 618.571  38.4026  H
   2 │ 648.868  22.5873  E
   3 │ 631.44   31.9274  M
```
Use the replicate design to compute standard errors of the estimated means.

```jldoctest meanlabel
julia> mean(:api00, :stype, bclus1)
3×3 DataFrame
 Row │ mean     SE       stype
     │ Float64  Float64  String
─────┼──────────────────────────
   1 │ 648.868  22.9491  E
   2 │ 631.44   32.0912  M
   3 │ 618.571  39.7277  H
```
"""
function mean(x::Symbol, domain, design::AbstractSurveyDesign)
    df = bydomain(x, domain, design, mean)
    return df
end
