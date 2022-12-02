"""
    quantile(var, design, q)
Estimate quantiles for `SurveyDesign`s.

```jldoctest
julia> apisrs = load_data("apisrs");

julia> srs = SimpleRandomSample(apisrs;popsize=:fpc);

julia> quantile(:enroll, srs, 0.5)
1×1 DataFrame
 Row │ 0.5th percentile
     │ Float64
─────┼──────────────────
   1 │            453.0
```
"""
function quantile(var, design::SimpleRandomSample, q; kwargs...)
    x = design.data[!, var]
    df = DataFrame(tmp = Statistics.quantile(Float32.(x), q; kwargs...))
    rename!(df, :tmp => Symbol(string(q) .* "th percentile"))
    return df
end

function quantile(var, design::StratifiedSample, q)
    x = design.data[!, var]
    w = design.data.probs
    df = DataFrame(tmp = Statistics.quantile(Float32.(x), weights(w), q))
    rename!(df, :tmp => Symbol(string(q) .* "th percentile"))
    return df
end

function quantile(var, design::design, q)
    x = design.variables[!, var]
    w = design.variables.probs
    df = DataFrame(tmp = Statistics.quantile(Float32.(x), weights(w), q))
    rename!(df, :tmp => Symbol(string(q) .* "th percentile"))

    return df
end

# Inner method for `by`
function quantile(x, w, _, q)
    df = DataFrame(tmp = Statistics.quantile(Float32.(x), weights(w), q))
    rename!(df, :tmp => Symbol(string(q) .* "th percentile"))

    return df
end