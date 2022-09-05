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

function var_of_mean(x::AbstractVector, design::SimpleRandomSample)
    return design.fpc / design.sampsize * var(x)
end

function sem(x::Symbol, design::SimpleRandomSample)
    return sqrt(var_of_mean(x, design))
end

function sem(x::AbstractVector, design::SimpleRandomSample)
    return sqrt(var_of_mean(x, design))
end

function svymean(x::Symbol, design::SimpleRandomSample)
    return DataFrame(mean = mean(design.data[!, x]), sem = sem(x, design::SimpleRandomSample))
end

function svymean(x::AbstractVector , design::SimpleRandomSample)
    return DataFrame(mean = mean(x), sem = sem(x, design::SimpleRandomSample))
end