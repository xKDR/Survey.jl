"""
    quantile(var, design, q; kwargs...)
Estimate quantiles for a complex survey.

Hyndman and Fan compiled a taxonomy of nine algorithms to estimate quantiles. These are implemented in Statistics.quantile, which this function calls.
The Julia, R and Python-numpy use the same defaults

# References:
Hyndman, R.J and Fan, Y. (1996) "Sample Quantiles in Statistical Packages", The American Statistician, Vol. 50, No. 4, pp. 361-365
[Quantiles](https://en.m.wikipedia.org/wiki/Quantile) on wikipedia
Section 2.4.1 and Appendix C.4 - [Complex Surveys: a guide to analysis using R](https://r-survey.r-forge.r-project.org/svybook/)

```jldoctest
julia> apisrs = load_data("apisrs");

julia> srs = SimpleRandomSample(apisrs;popsize=:fpc);

julia> quantile(:enroll, srs, 0.5)
1×1 DataFrame
 Row │ 0.5th percentile
     │ Float64
─────┼──────────────────
   1 │            453.0

julia> quantile(:enroll, srs, [0.25,0.75, 0.99])
3×1 DataFrame
 Row │ [0.25, 0.75, 0.99]th percentile 
     │ Float64                         
─────┼─────────────────────────────────
   1 │                          339.0
   2 │                          668.5
   3 │                         1911.39

julia> strat = load_data("apistrat");

julia> dstrat = StratifiedSample(strat, :stype; popsize=:fpc);

julia> quantile(:enroll, dstrat, [0.1,0.2,0.5,0.75,0.95])

```
"""
function quantile(var::Symbol, design::SimpleRandomSample, q::Union{<:Real,Vector{<:Real}}; alpha::Real=1.0, beta::Real=alpha, kwargs...)
    x = design.data[!, var]
    df = DataFrame(qth_quantile = q, quantile = Statistics.quantile(Float32.(x), q; kwargs...))
    return df
end

function quantile(var::Symbol, design::StratifiedSample, q::Union{<:Real,Vector{<:Real}}; kwargs...)
    x = design.data[!, var]
    w = design.data.probs
    df = DataFrame(qth_quantile = q, quantile = Statistics.quantile(Float32.(x), weights(w), q))
    return df
end