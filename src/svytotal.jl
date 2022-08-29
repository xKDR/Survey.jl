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
Yt = N * mean
var of total = N ^2 * V(ȳ)
"""
function var_of_total(variable,design::SimpleRandomSample)
    return design.pop_size ^2 * design.fpc / design.sample_size * var(design.data[!, variable])
end

function standardErrorOfTotal(variable,design::SimpleRandomSample)
    return sqrt(var_of_total(variable,design))
end

# Dont use var as name of variable as it is function for variance.
function svytotal(variable,design::SimpleRandomSample)
    # total = design.pop_size * mean(design.data[!, variable])
    total = wsum(design.data[!, variable] , weights(design.data.weights)  )
    print(total)
    return DataFrame(total = total , SE = standardErrorOfTotal(variable,design::SimpleRandomSample)  )
end
# TODO: check later
"""
Internal method used by `svyby`.
"""
function svytotal(var, wts, _)
    DataFrame(total = wsum(Float32.(var), weights(1 ./ wts)))
end
