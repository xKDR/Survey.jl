"""
    quantile(var, design, p; kwargs...)
Estimate quantile of a variable.

Hyndman and Fan compiled a taxonomy of nine algorithms to estimate quantiles. These are implemented in Statistics.quantile, which this function calls.
Julia, R and Python-numpy use the same defaults

# References:
- Hyndman, R.J and Fan, Y. (1996) ["Sample Quantiles in Statistical Packages"](https://www.amherst.edu/media/view/129116/original/Sample+Quantiles.pdf), The American Statistician, Vol. 50, No. 4, pp. 361-365.
- [Quantiles](https://en.m.wikipedia.org/wiki/Quantile) on wikipedia
- [Complex Surveys: a guide to analysis using R](https://r-survey.r-forge.r-project.org/svybook/), Section 2.4.1 and Appendix C.4.

```jldoctest
julia> apisrs = load_data("apisrs");

julia> srs = SurveyDesign(apisrs; weights=:pw); 

julia> quantile(:api00, srs, 0.5)
1×1 DataFrame
 Row │ 0.5th percentile
     │ Float64
─────┼──────────────────
   1 │            659.0
```
"""
function quantile(var::Symbol, design::SurveyDesign, p::Real; kwargs...)
    v = design.data[!, var]
    probs = design.data[!, design.allprobs]
    X = Statistics.quantile(v, ProbabilityWeights(probs), p)
    df = DataFrame(percentile = X)
    rename!(df, :percentile => string(p) * "th percentile")
    return df
end

"""
Use replicate weights to compute the standard error of the estimated quantile. 

```jldoctest; setup = :(apisrs = load_data("apisrs");srs = SurveyDesign(apisrs; weights=:pw))
julia> bsrs = srs |> bootweights; 

julia> quantile(:api00, bsrs, 0.5)
1×2 DataFrame
 Row │ 0.5th percentile  SE
     │ Float64           Float64
─────┼───────────────────────────
   1 │            659.0  14.9764
```
"""
function quantile(var::Symbol, design::ReplicateDesign, p::Real; kwargs...)
    quantile_func(v, weights) = Statistics.quantile(v, ProbabilityWeights(weights), p)
    df = Survey.variance(var, quantile_func, design)
    rename!(df, :estimator => string(p) * "th percentile")
    return df
end

"""
    quantile(var, design, p; kwargs...)
Estimate quantiles of a list of variables.

```jldoctest; setup = :(apisrs = load_data("apisrs"); srs = SurveyDesign(apisrs; weights=:pw); )
julia> quantile(:enroll, srs, [0.1,0.2,0.5,0.75,0.95])
5×2 DataFrame
 Row │ percentile  statistic
     │ String      Float64
─────┼───────────────────────
   1 │ 0.1             245.5
   2 │ 0.2             317.6
   3 │ 0.5             453.0
   4 │ 0.75            668.5
   5 │ 0.95           1473.1
```
"""
function quantile(var::Symbol, design::SurveyDesign, probs::Vector{<:Real}; kwargs...) # A function with AbstractSurveyDesign might be able to achieve both with and without SE. 
    df = vcat(
        [
            rename!(quantile(var, design, prob; kwargs...), [:statistic]) for prob in probs
        ]...,
    )
    df.percentile = string.(probs)
    return df[!, [:percentile, :statistic]]
end

"""

Use replicate weights to compute the standard errors of the estimated quantiles. 

```jldoctest; setup = :(apisrs = load_data("apisrs"); srs = SurveyDesign(apisrs; weights=:pw); bsrs = SurveyDesign(apisrs; weights=:pw) |> bootweights)
julia> quantile(:enroll, bsrs, [0.1,0.2,0.5,0.75,0.95])
5×3 DataFrame
 Row │ percentile  statistic  SE       
     │ String      Float64    Float64  
─────┼─────────────────────────────────
   1 │ 0.1             245.5   20.2964
   2 │ 0.2             317.6   13.5435
   3 │ 0.5             453.0   24.9719
   4 │ 0.75            668.5   34.2487
   5 │ 0.95           1473.1  142.568
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
