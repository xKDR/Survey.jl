"""
    quantile(var, design, p; kwargs...)
Estimate quantiles for a complex survey.

Hyndman and Fan compiled a taxonomy of nine algorithms to estimate quantiles. These are implemented in Statistics.quantile, which this function calls.
The Julia, R and Python-numpy use the same defaults

# References:
- Hyndman, R.J and Fan, Y. (1996) ["Sample Quantiles in Statistical Packages"](https://www.amherst.edu/media/view/129116/original/Sample+Quantiles.pdf), The American Statistician, Vol. 50, No. 4, pp. 361-365.
- [Quantiles](https://en.m.wikipedia.org/wiki/Quantile) on wikipedia
- [Complex Surveys: a guide to analysis using R](https://r-survey.r-forge.r-project.org/svybook/), Section 2.4.1 and Appendix C.4.

```jldoctest
julia> apisrs = load_data("apisrs");

julia> srs = SurveyDesign(apisrs; weights=:pw) |> bootweights; 

julia> quantile(:api00,srs,0.5)
1×2 DataFrame
 Row │ 0.5th percentile  SE      
     │ Float64           Float64 
─────┼───────────────────────────
   1 │            659.0  14.9764
```
"""
function quantile(var::Symbol, design::ReplicateDesign, p::Real;kwargs...)
    v = design.data[!, var]
    probs = design.data[!, design.allprobs]
    X = Statistics.quantile(v, ProbabilityWeights(probs), p)
    Xt = [Statistics.quantile(v, ProbabilityWeights(design.data[! , "replicate_"*string(i)]), p) for i in 1:design.replicates]
    variance = sum((Xt .- X).^2) / design.replicates
    df = DataFrame(percentile = X, SE = sqrt(variance))
    rename!(df, :percentile => string(p) * "th percentile")
    return df
end

"""
```jldoctest
julia> apisrs = load_data("apisrs");

julia> srs = SurveyDesign(apisrs; weights=:pw) |> bootweights; 

julia> quantile(:enroll,srs,[0.1,0.2,0.5,0.75,0.95])
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
function quantile(var::Symbol, design::ReplicateDesign, probs::Vector{<:Real}; kwargs...)
    df = vcat([rename!(quantile(var, design, prob; kwargs...),[:statistic, :SE]) for prob in probs]...)
    df.percentile = string.(probs)
    return df[!, [:percentile, :statistic, :SE]]
end