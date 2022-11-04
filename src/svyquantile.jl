"""
    svyquantile(var, design, q)
Estimate quantiles for `SurveyDesign`s.

```jldoctest
julia> apisrs = load_data("apisrs");

julia> srs = SimpleRandomSample(apisrs; weights = :pw);

julia> svyquantile(:enroll, srs, 0.5)
1×1 DataFrame
 Row │ 0.5th percentile
     │ Float64
─────┼──────────────────
   1 │            453.0
```
"""
function svyquantile(var, design::SimpleRandomSample, q; kwargs...)
    x = design.data[!, var]
    df = DataFrame(tmp = quantile(Float32.(x), q; kwargs...))
    rename!(df, :tmp => Symbol(string(q) .* "th percentile"))
    return df
end

function svyquantile(var, design::StratifiedSample, q)
    x = design.data[!, var]
    w = design.data.probs
    df = DataFrame(tmp = quantile(Float32.(x), weights(w), q))
    rename!(df, :tmp => Symbol(string(q) .* "th percentile"))

    return df
end

function svyquantile(var, design::svydesign, q)
    x = design.variables[!, var]
    w = design.variables.probs
    df = DataFrame(tmp = quantile(Float32.(x), weights(w), q))
    rename!(df, :tmp => Symbol(string(q) .* "th percentile"))

    return df
end

# Inner method for `svyby`
function svyquantile(x, w, _, q)
    df = DataFrame(tmp = quantile(Float32.(x), weights(w), q))
    rename!(df, :tmp => Symbol(string(q) .* "th percentile"))

    return df
end
