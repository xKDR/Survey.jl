"""
Estimate the population total for the variable specified by `var`.

```jldoctest
julia> using Survey

julia> apisrs = load_data("apisrs");

julia> srs = SimpleRandomSample(apisrs);

julia> svytotal(:enroll, srs)
1×1 DataFrame
 Row │ total
     │ Float64
─────┼──────────
   1 │ 116922.0
```
"""
function svytotal(var, design::SurveyDesign)
    wts = design.data.probs;  # probability weights
    x = design.data[!, var];  # column for which the total is calculated

    # return the weighted sum as a data frame
    DataFrame(total = wsum(Float32.(x), weights(1 ./ wts)));
end

"""
The `svytotal` function can also be used with a `svydesign` object.
"""
function svytotal(var, design::svydesign)
    wts = design.variables.probs;
    x = design.variables[!, var];
    df = DataFrame(total = wsum(Float32.(x), weights(1 ./ wts)));
    return df
end

"""
Internal method used by `svyby`.
"""
function svytotal(var, wts, _)
    DataFrame(total = wsum(Float32.(var), weights(1 ./ wts)))
end
