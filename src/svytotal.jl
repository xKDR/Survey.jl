"""
Estimate the population total for the variable specified by `var`.

```jldoctest
julia> using Survey

julia> apisrs = load_data("apisrs");

julia> srs = SimpleRandomSample(apisrs);

julia> svytotal(:enroll, srs)
┌ Warning: this is the standard error of the mean
└ @ Survey ~/GSoC/Survey.jl/src/svytotal.jl:25
1×2 DataFrame
 Row │ total     SE
     │ Float64   Float64
─────┼───────────────────
   1 │ 116922.0  27.8212
```
"""
# TODO: standard error
function svytotal(var, design::SimpleRandomSample)
    wts = design.data.probs;  # probability weights
    x = design.data[!, var];  # column for which the total is calculated
    # standard error of total - SHOULD BE AN EXTERNAL FUNCTION
    function SE(x, w)
        # remove the warning once the function is fixed
        # DON'T FORGET TO REMOVE FROM DOCTEST
        @warn "this is the standard error of the mean"
        var = sum(w .* (x .- sum(w .* x) / sum(w)).^2) / sum(w)
        sd = sqrt(var / (length(x) - 1))
        return sd
    end

    # return the weighted sum and standard error as a data frame
    DataFrame(total = wsum(Float32.(x), weights(1 ./ wts)), SE = SE(x, wts));
end

# TODO: standard error
function svytotal(var, design::StratifiedSample)
    wts = design.data.probs;  # probability weights
    x = design.data[!, var];  # column for which the total is calculated
    strata = design.data.strata
    # standard error of total - SHOULD BE AN EXTERNAL FUNCTION
    # change SE to account for stratification
    function SE(x, w)
        # remove the warning once the function is fixed
        # DON'T FORGET TO REMOVE FROM DOCTEST
        @warn "this is the standard error of the mean"
        var = sum(w .* (x .- sum(w .* x) / sum(w)).^2) / sum(w)
        sd = sqrt(var / (length(x) - 1))
        return sd
    end

    # return the weighted sum and standard error as a data frame
    DataFrame(total = wsum(Float32.(x), weights(1 ./ wts)), SE = SE(x, wts));
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
