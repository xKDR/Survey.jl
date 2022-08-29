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
Variance of x̄ in SRS, V̂(x̄) = (1-n/N) / n * s²ₓ 
SE of x̄ in SRS = sqrt(V̂(x̄))
"""
function var_of_mean(variable,design::SimpleRandomSample)
    return design.fpc / design.sample_size * var(design.data[!, variable])
end

function standardErrorOfMean(variable,design::SimpleRandomSample)
    return sqrt(var_of_mean(variable,design))
end

# Dont use var as name of variable as it is function for variance.
function svymean(variable,design::SimpleRandomSample)
    return DataFrame(mean = mean(design.data[!, variable]), SE = standardErrorOfMean(variable,design::SimpleRandomSample)  )
end

# TODO: this need work
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
