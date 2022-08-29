"""
    svymean(x, design)

Compute the mean and standard error of the survey variable `x`.

```jldoctest
julia> using Survey

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
function svymean(x::Symbol, design::SimpleRandomSample)
    return DataFrame(mean = mean(design.data[!, x]), sem = StatsBase.sem(design.data[!, x]))
end
