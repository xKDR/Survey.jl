"""
Compute the mean of the survey variable `var`.

```jldoctest
julia> using Survey

julia> apisrs = load_data("apisrs");

julia> srs = SimpleRandomSample(apisrs);

julia> svymean(:enroll, srs)
1×2 DataFrame
 Row │ mean     SE
     │ Float64  Float64
─────┼──────────────────
   1 │  584.61  27.8212
```
"""
# TODO: modify documentation to account for SimpleRandomSample
# TODO: use more descriprive variable names
function svymean(var, design::SimpleRandomSample)
    # popsize correction isn't implemented yet
    ss = maximum(design.data.sampsize)
    w = design.data.probs
    x = design.data[!, var]
    function SE(x, w, ss)
        f = sqrt(1 - 1 / length(x) + 1 / ss)
        x1 = sum(w .* (x .- sum(w .* x) / sum(w)).^2) / sum(w)
        sd = sqrt(x1 / (length(x) - 1))
        return f * sd
    end

    return DataFrame(mean = mean(x, weights(w)), SE = SE(x, w, ss))
end

# TODO
# function svymean(var, design::StratifiedSample)
#     # popsize correction isn't implemented yet
#     ss = maximum(design.data.sampsize)
#     w = design.data.probs
#     x = design.data[!, var]
#     strata = groupby(design.data.strata)
#     function SE(x, w, ss)
#         f = sqrt(1 - 1 / length(x) + 1 / ss)
#         x1 = sum(w .* (x .- sum(w .* x) / sum(w)).^2) / sum(w)
#         sd = sqrt(x1 / (length(x) - 1))
#         return f * sd
#     end

#     return DataFrame(mean = mean(x, weights(w)), SE = SE(x, w, ss))
# end

"""
Method for designs of type `svydesign`.
"""
function svymean(y, design::svydesign)
    # popsize correction isn't implemented yet
    ss = maximum(design.variables.sampsize)
    w = design.variables.probs
    x = design.variables[!, y]
    function SE(x, w, ss)
        f = sqrt(1 - 1 / length(x) + 1 / ss)
        var = sum(w .* (x .- sum(w .* x) / sum(w)).^2) / sum(w)
        sd = sqrt(var / (length(x) - 1))
        return f * sd
    end

    return DataFrame(mean = mean(x, weights(w)), SE = SE(x, w, ss))
end

"""
Inner function used by `svyby`.
"""
function svymean(x, w, sampsize)
    # popsize correction isn't implemented yet
    ss = maximum(sampsize)
    function SE(x, w, ss)
        f = sqrt(1 - 1/length(x) + 1/ss)
        var = sum(w.*(x.- sum(w.*x)/sum(w)).^2)/sum(w)
        sd = sqrt(var / (length(x) -1))
        return f * sd
    end

    return DataFrame(mean = mean(x, weights(w)), SE = SE(x, w, ss))
end
