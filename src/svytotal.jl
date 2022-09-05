"""
    svytotal(x, design)

Estimate the population total for the variable specified by `x`.

```jldoctest
julia> apisrs = load_data("apisrs");

julia> srs = SimpleRandomSample(apisrs);

julia> svytotal(:enroll, srs)
1×2 DataFrame
 Row │ total     se_total
     │ Float64   Float64
─────┼────────────────────
   1 │ 116922.0   5564.24
```
"""
function var_of_total(x::Symbol, design::SimpleRandomSample)
    return design.popsize^2 * design.fpc / design.sampsize * var(design.data[!, x])
end

"""
Inner method for `svyby`.
"""
function var_of_total(x::AbstractVector, design::SimpleRandomSample)
    return design.popsize^2 * design.fpc / design.sampsize * var(x)
end

function se_tot(x::Symbol, design::SimpleRandomSample)
    return sqrt(var_of_total(x, design))
end

"""
Inner method for `svyby`.
"""
function se_tot(x::AbstractVector, design::SimpleRandomSample)
    return sqrt(var_of_total(x, design))
end

function svytotal(x::Symbol, design::SimpleRandomSample)
    # total = design.pop_size * mean(design.data[!, variable])
    total = wsum(design.data[!, x] , weights(design.data.weights))
    return DataFrame(total = total , se_total = se_tot(x, design::SimpleRandomSample))
end

"""
Inner method for `svyby`.
"""
# TODO: results not matching for `sem`
function svytotal(x::AbstractArray, design::SimpleRandomSample, wts)
    total = wsum(x, weights(wts))
    return DataFrame(total = total , se_total = se_tot(x, design::SimpleRandomSample))
end

function svytotal(x::Symbol, design::svydesign)
    # TODO
end
