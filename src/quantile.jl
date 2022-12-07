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

julia> srs = SimpleRandomSample(apisrs;popsize=:fpc);

julia> quantile(:api00,srs,0.5)
1×2 DataFrame
 Row │ probability  quantile 
     │ Float64      Float64  
─────┼───────────────────────
   1 │         0.5     659.0

julia> quantile(:enroll,srs,[0.1,0.2,0.5,0.75,0.95])
5×2 DataFrame
 Row │ probability  quantile 
     │ Float64      Float64  
─────┼───────────────────────
   1 │        0.1      245.5
   2 │        0.2      317.6
   3 │        0.5      453.0
   4 │        0.75     668.5
   5 │        0.95    1473.1
```
"""
function quantile(var::Symbol, design::SimpleRandomSample, p::Union{<:Real,Vector{<:Real}}; ci::Bool=false, se::Bool=false, kwargs...)
    v = design.data[!, var]
    probs = design.data[!, :probs]
    df = DataFrame(probability = p, quantile = Statistics.quantile(v, ProbabilityWeights(probs),p))
    # TODO: Add CI and SE of the quantile
    return df
end

function quantile(var::Symbol, design::StratifiedSample, p::Union{<:Real,Vector{<:Real}}; ci::Bool=false, se::Bool=false, kwargs...)
    v = design.data[!, var]
    probs = design.data[!, :probs]
    df = DataFrame(probability = p, quantile = Statistics.quantile(v, ProbabilityWeights(probs), p))
    return df
end