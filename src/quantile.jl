"""
    quantile(var, design, p; ci = false, alpha = 0.05)

Estimate quantiles of a variable, following `oldsvyquantile` in the R `survey`
package (with `ties = "discrete"` and linear interpolation): the estimate is the
inverse of the weighted cumulative distribution function, interpolated linearly
between distinct jump points.

With `ci = true`, a Woodruff-type confidence interval (R's
`interval.type = "Wald"`) and the derived standard error are also returned: a
confidence interval for the cumulative probability `p` is computed using the
linearized standard error of the estimated CDF and t quantiles with
[`degf`](@ref) degrees of freedom, and is then inverted through the estimated
CDF.

```jldoctest; setup = :(using Survey)
julia> apisrs = load_data("apisrs");

julia> srs = SurveyDesign(apisrs; weights=:pw);

julia> quantile(:api00, srs, 0.5)
1×1 DataFrame
 Row │ 0.5th percentile
     │ Float64
─────┼──────────────────
   1 │            658.0

julia> quantile(:api00, srs, 0.5; ci = true)
1×4 DataFrame
 Row │ 0.5th percentile  SE       ci_lower  ci_upper
     │ Float64           Float64  Float64   Float64
─────┼───────────────────────────────────────────────
   1 │            658.0   15.699   631.042   692.958
```

# References:
- [Complex Surveys: a guide to analysis using R](https://r-survey.r-forge.r-project.org/svybook/), Section 2.4.1 and Appendix C.4.
- Woodruff, R.S. (1952). "Confidence intervals for medians and other position measures", JASA 47, 635-646.
"""
function quantile(var::Symbol, design::SurveyDesign, p::Real; ci::Bool = false, alpha::Real = 0.05, kwargs...)
    x = design.data[!, var]
    w = design.data[!, design.weights]
    X = _weighted_quantile(x, w, p)
    df = DataFrame(Symbol(string(p) * "th percentile") => X)
    if ci
        # Woodruff: a CI for the cumulative probability p, inverted through the CDF
        U = Float64.(x .> X) .- (1 - p)
        se_p, _ = _se_mean(U, design)
        q_crit = quantile(TDist(degf(design)), 1 - alpha / 2)
        lower = _weighted_quantile(x, w, p - q_crit * se_p)
        upper = _weighted_quantile(x, w, p + q_crit * se_p)
        df[!, :SE] = [(upper - lower) / (2 * q_crit)]
        df[!, :ci_lower] = [lower]
        df[!, :ci_upper] = [upper]
    end
    return df
end

# The weighted quantile used by R's oldsvyquantile with ties = "discrete":
# linear interpolation of the inverse of the weighted CDF, clamped to the
# observed range.
function _weighted_quantile(x::AbstractVector, w::AbstractVector, p::Real)
    # stable sort so that tied values keep their data order, as R's order()
    order = sortperm(x; alg = Base.Sort.DEFAULT_STABLE)
    xs = Float64.(x[order])
    cw = cumsum(Float64.(w[order])) ./ sum(w)
    # collapse duplicate cumulative-weight values (zero weights), keeping the
    # smallest x, as R's approxfun(..., ties = min)
    knots_x = Float64[]
    knots_y = Float64[]
    for i in eachindex(cw)
        if !isempty(knots_x) && cw[i] == knots_x[end]
            continue
        end
        push!(knots_x, cw[i])
        push!(knots_y, xs[i])
    end
    p <= knots_x[1] && return p < knots_x[1] ? xs[1] : knots_y[1]
    p >= knots_x[end] && return p > knots_x[end] ? xs[end] : knots_y[end]
    k = searchsortedlast(knots_x, p)
    knots_x[k] == p && return knots_y[k]
    λ = (p - knots_x[k]) / (knots_x[k+1] - knots_x[k])
    return knots_y[k] + λ * (knots_y[k+1] - knots_y[k])
end

"""
    quantile(x::Symbol, design::ReplicateDesign, p; kwargs...)

Compute the standard error of the estimated quantile using replicate weights.

# Arguments
- `x::Symbol`: Symbol representing the variable for which the quantile is estimated.
- `design::ReplicateDesign`: Replicate design object.
- `p::Real`: Quantile value to estimate, ranging from 0 to 1.
- `kwargs...`: Additional keyword arguments.

# Returns
- `df`: DataFrame containing the estimated quantile and its standard error.

# Examples

```jldoctest; setup = :(using Survey, StatsBase; apisrs = load_data("apisrs"); srs = SurveyDesign(apisrs; weights=:pw); bsrs = srs |> bootweights)
julia> quantile(:api00, bsrs, 0.5)
1×2 DataFrame
 Row │ 0.5th percentile  SE
     │ Float64           Float64
─────┼───────────────────────────
   1 │            658.0  14.8882
```
"""
function quantile(x::Symbol, design::ReplicateDesign, p::Real; kwargs...)

    # Define an inner function to calculate the quantile
    function inner_quantile(df::DataFrame, column, weights_column)
        return _weighted_quantile(df[!, column], df[!, weights_column], p)
    end

    # Calculate the quantile and standard error
    df = standarderror(x, inner_quantile, design)

    rename!(df, :estimator => string(p) * "th percentile")

    return df
end

"""
    quantile(var, design, p; kwargs...)
Estimate quantiles of a list of variables.

```jldoctest; setup = :(using Survey; apisrs = load_data("apisrs"); srs = SurveyDesign(apisrs; weights=:pw); )
julia> quantile(:enroll, srs, [0.1,0.2,0.5,0.75,0.95])
5×2 DataFrame
 Row │ percentile  statistic
     │ String      Float64
─────┼───────────────────────
   1 │ 0.1             232.0
   2 │ 0.2             316.0
   3 │ 0.5             453.0
   4 │ 0.75            664.0
   5 │ 0.95           1467.0
```
"""
function quantile(var::Symbol, design::SurveyDesign, probs::Vector{<:Real}; ci::Bool = false, kwargs...)
    dfs = [quantile(var, design, prob; ci = ci, kwargs...) for prob in probs]
    if ci
        dfs = [rename!(df, [:statistic, :SE, :ci_lower, :ci_upper]) for df in dfs]
        df = vcat(dfs...)
        df.percentile = string.(probs)
        return df[!, [:percentile, :statistic, :SE, :ci_lower, :ci_upper]]
    end
    df = vcat([rename!(d, [:statistic]) for d in dfs]...)
    df.percentile = string.(probs)
    return df[!, [:percentile, :statistic]]
end

"""

Use replicate weights to compute the standard errors of the estimated quantiles.

```jldoctest; setup = :(using Survey; apisrs = load_data("apisrs"); srs = SurveyDesign(apisrs; weights=:pw); bsrs = SurveyDesign(apisrs; weights=:pw) |> bootweights)
julia> quantile(:enroll, bsrs, [0.1,0.2,0.5,0.75,0.95])
5×3 DataFrame
 Row │ percentile  statistic  SE
     │ String      Float64    Float64
─────┼─────────────────────────────────
   1 │ 0.1             232.0   21.379
   2 │ 0.2             316.0   14.212
   3 │ 0.5             453.0   24.2575
   4 │ 0.75            664.0   33.6377
   5 │ 0.95           1467.0  142.984
```
"""
function quantile(
    var::Symbol,
    design::AbstractSurveyDesign,
    probs::Vector{<:Real};
    kwargs...,
)
    df = vcat(
        [
            rename!(quantile(var, design, prob; kwargs...), [:statistic, :SE]) for
            prob in probs
        ]...,
    )
    df.percentile = string.(probs)
    return df[!, [:percentile, :statistic, :SE]]
end

"""
quantile(var, domain, design)

Estimate a quantile of domains.

```jldoctest meanlabel; setup = :(using Survey, StatsBase; apiclus1 = load_data("apiclus1"); dclus1 = SurveyDesign(apiclus1; clusters = :dnum, weights = :pw); bclus1 = dclus1 |> bootweights)
julia> quantile(:api00, :cname, dclus1, 0.5)
11×2 DataFrame
 Row │ 0.5th percentile  cname
     │ Float64           String
─────┼───────────────────────────────
   1 │            666.5  Alameda
   2 │            467.0  Fresno
   3 │            411.0  Kern
   4 │            628.0  Los Angeles
   5 │            602.0  Mendocino
   6 │            510.0  Merced
   7 │            715.0  Orange
   8 │            695.0  Plumas
   9 │            656.5  San Diego
  10 │            538.5  San Joaquin
  11 │            717.0  Santa Clara
```
"""
function quantile(x::Symbol, domain, design::AbstractSurveyDesign, p::Real)
    df = bydomain(x, domain, design, quantile, p)
    return df
end
