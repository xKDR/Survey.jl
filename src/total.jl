"""
    total(var, design)

Estimate the population total of a variable, with the standard error computed by
Taylor linearization (the default variance method of the R `survey` package).
When the design was constructed with an explicit `popsize`, a finite population
correction is applied, as in R.

If `var` is a categorical variable, the estimated population count of each level
is returned, matching `svytotal` on a factor in R.

```jldoctest; setup = :(using Survey)
julia> apiclus1 = load_data("apiclus1");

julia> dclus1 = SurveyDesign(apiclus1; clusters = :dnum, weights = :pw);

julia> total(:api00, dclus1)
1×2 DataFrame
 Row │ total      SE
     │ Float64    Float64
─────┼──────────────────────
   1 │ 3.98999e6  9.07399e5
```
"""
function total(x::Symbol, design::SurveyDesign)
    col = design.data[!, x]
    if _iscategorical(col)
        levels, totals, ses = _category_totals(col, design)
        return DataFrame(level = levels, total = totals, SE = ses)
    end
    X = wsum(col, weights(design.data[!, design.weights]))
    DataFrame(total = X, SE = _se_total(col, design))
end

# population count of each level of a categorical variable with linearized SEs
function _category_totals(col::AbstractVector, design::SurveyDesign)
    levels = sort!(unique(col))
    w = weights(design.data[!, design.weights])
    totals = Float64[]
    ses = Float64[]
    for level in levels
        indicator = Float64.(col .== level)
        push!(totals, wsum(indicator, w))
        push!(ses, _se_total(indicator, design))
    end
    return string.(levels), totals, ses
end

"""
    total(x::Symbol, design::ReplicateDesign)

Compute the standard error of the estimated total using replicate weights. For a
categorical variable, population counts of each level are estimated.

# Arguments
- `x::Symbol`: Symbol representing the variable for which the total is estimated.
- `design::ReplicateDesign`: Replicate design object.

# Returns
- `df`: DataFrame containing the estimated total and its standard error.

# Examples

```jldoctest; setup = :(using Survey; apiclus1 = load_data("apiclus1"); dclus1 = SurveyDesign(apiclus1; clusters = :dnum, weights = :pw); bclus1 = dclus1 |> bootweights)
julia> total(:api00, bclus1)
1×2 DataFrame
 Row │ total      SE
     │ Float64    Float64
─────┼──────────────────────
   1 │ 3.98999e6  8.99664e5
```
"""
function total(x::Symbol, design::ReplicateDesign)

    if _iscategorical(design.data[!, x])
        levels = sort!(unique(design.data[!, x]))

        function inner_counts(df::DataFrame, column, weights_column)
            w = StatsBase.weights(df[!, weights_column])
            return [StatsBase.wsum(Float64.(df[!, column] .== level), w) for level in levels]
        end

        df = standarderror(x, inner_counts, design)
        rename!(df, :estimator => :total)
        insertcols!(df, 1, :level => string.(levels))
        return df
    end

    # Define an inner function to calculate the total
    function inner_total(df::DataFrame, column, weights)
        return StatsBase.wsum(df[!, column], StatsBase.weights(df[!, weights]))
    end

    # Calculate the total and standard error
    df = standarderror(x, inner_total, design)

    rename!(df, :estimator => :total)

    return df
end

"""
Estimate the population total of a list of variables.

```jldoctest totallabel; setup = :(using Survey; apiclus1 = load_data("apiclus1"); dclus1 = SurveyDesign(apiclus1; clusters = :dnum, weights = :pw); bclus1 = dclus1 |> bootweights)
julia> total([:api00, :enroll], dclus1)
2×3 DataFrame
 Row │ names   total      SE
     │ String  Float64    Float64
─────┼──────────────────────────────
   1 │ api00   3.98999e6  9.07399e5
   2 │ enroll  3.40494e6  9.41611e5
```

Use replicate weights to compute the standard error of the estimated totals.

```jldoctest totallabel
julia> total([:api00, :enroll], bclus1)
2×3 DataFrame
 Row │ names   total      SE
     │ String  Float64    Float64
─────┼───────────────────────────────────
   1 │ api00   3.98999e6       8.99664e5
   2 │ enroll  3.40494e6  934764.0
```
"""
function total(x::Vector{Symbol}, design::AbstractSurveyDesign)
    df = reduce(vcat, [total(i, design) for i in x])
    insertcols!(df, 1, :names => String.(x))
    return df
end

"""
    total(var, domain, design)

Estimate population totals of domains. For a `SurveyDesign`, standard errors are
computed by Taylor linearization using the full design structure, matching
`svyby` with `svytotal` in R.

```jldoctest totallabel; setup = :(using Survey; apiclus1 = load_data("apiclus1"); dclus1 = SurveyDesign(apiclus1; clusters = :dnum, weights = :pw); bclus1 = dclus1 |> bootweights)
julia> total(:api00, :cname, dclus1)
11×3 DataFrame
 Row │ total           SE              cname
     │ Float64         Float64         String
─────┼─────────────────────────────────────────────
   1 │ 249080.0        249080.0        Alameda
   2 │  63903.1         63903.1        Fresno
   3 │  30631.5         30631.5        Kern
   4 │      3.2862e5        2.90602e5  Los Angeles
   5 │  84380.6         84380.6        Mendocino
   6 │  70300.2         70300.2        Merced
   7 │      3.84807e5       3.84807e5  Orange
   8 │      2.16147e5       2.16147e5  Plumas
   9 │      1.2276e6        8.64079e5  San Diego
  10 │      6.90276e5       6.90276e5  San Joaquin
  11 │      6.44244e5       4.2477e5   Santa Clara
```
Use the replicate design to compute standard errors of the estimated totals.

```jldoctest totallabel
julia> total(:api00, :cname, bclus1)
11×3 DataFrame
 Row │ total           SE              cname
     │ Float64         Float64         String
─────┼─────────────────────────────────────────────
   1 │      6.44244e5       4.23593e5  Santa Clara
   2 │      1.2276e6        8.70396e5  San Diego
   3 │  70300.2         71013.5        Merced
   4 │      3.2862e5        2.93779e5  Los Angeles
   5 │      3.84807e5       3.85726e5  Orange
   6 │  63903.1         63931.2        Fresno
   7 │      2.16147e5       2.17844e5  Plumas
   8 │ 249080.0        251777.0        Alameda
   9 │      6.90276e5       6.94712e5  San Joaquin
  10 │  30631.5         30112.9        Kern
  11 │  84380.6         85099.9        Mendocino
```
"""
function total(x::Symbol, domain, design::AbstractSurveyDesign)
    df = bydomain(x, domain, design, total)
    return df
end
