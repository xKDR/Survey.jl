"""
Compute the mean of the survey variable `var`.

```jldoctest
julia> apisrs = load_data("apisrs");

julia> srs = SimpleRandomSample(apisrs);

julia> svymean(:enroll, srs)
1×2 DataFrame
 Row │ mean     sem
     │ Float64  Float64
─────┼──────────────────
   1 │  584.61  27.8212
```
"""
function var_of_mean(x::Symbol, design::SimpleRandomSample)
    return design.fpc / design.sampsize * var(design.data[!, x])
end

"""
Inner method for `svyby`.
"""
function var_of_mean(x::AbstractVector, design::SimpleRandomSample)
    return design.fpc / design.sampsize * var(x)
end

function sem(x::Symbol, design::SimpleRandomSample)
    return sqrt(var_of_mean(x, design))
end

"""
Inner method for `svyby`.
"""
function sem(x::AbstractVector, design::SimpleRandomSample)
    return sqrt(var_of_mean(x, design))
end

"""
    svymean(x, design)

Compute the mean and SEM of the variable `x`.
"""
function svymean(x::Symbol, design::SimpleRandomSample)
    return DataFrame(mean = mean(design.data[!, x]), sem = sem(x, design::SimpleRandomSample))
end

"""
Inner method for `svyby`.
"""
function svymean(x::AbstractVector , design::SimpleRandomSample, _)
    # TODO: results not matching for `sem`
    return DataFrame(mean = mean(x), sem = sem(x, design::SimpleRandomSample))
end
