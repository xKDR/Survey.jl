"""
    var(x, design)

Estimate the population variance of a variable, with its standard error. Follows
`svyvar` in the R `survey` package: the estimate is
``\\dfrac{n}{n-1} \\dfrac{\\sum_i w_i (y_i - \\bar{y}_w)^2}{\\sum_i w_i}``,
and the standard error is that of the weighted mean of the (scaled) squared
deviations.

```jldoctest; setup = :(using Survey)
julia> apisrs = load_data("apisrs");

julia> srs = SurveyDesign(apisrs; weights=:pw);

julia> var(:api00, srs)
1×2 DataFrame
 Row │ var      SE
     │ Float64  Float64
─────┼──────────────────
   1 │ 17682.4  1371.56
```
"""
function var(x::Symbol, design::SurveyDesign)
    y = design.data[!, x]
    w = design.data[!, design.weights]
    n = count(!=(0), w)
    μ = sum(w .* y) / sum(w)
    z = (y .- μ) .^ 2 .* (n / (n - 1))
    se, v = _se_mean(z, design)
    DataFrame(var = v, SE = se)
end

"""
    var(x, design::ReplicateDesign)

Estimate the population variance of a variable using replicate weights. The
variance (including the weighted mean) is recomputed with each set of replicate
weights, matching `svyvar` for replicate designs in R.
"""
function var(x::Symbol, design::ReplicateDesign)
    n = nrow(design.data)

    function inner_var(df::DataFrame, column, weights_column)
        y = df[!, column]
        w = df[!, weights_column]
        μ = sum(w .* y) / sum(w)
        return (n / (n - 1)) * sum(w .* (y .- μ) .^ 2) / sum(w)
    end

    df = standarderror(x, inner_var, design)
    rename!(df, :estimator => :var)
    return df
end

"""
    std(x, design)

Estimate the population standard deviation of a variable: the square root of
[`var`](@ref). The standard error is obtained from the standard error of the
variance by the delta method.
"""
function std(x::Symbol, design::AbstractSurveyDesign)
    v = var(x, design)
    s = sqrt.(v.var)
    DataFrame(std = s, SE = v.SE ./ (2 .* s))
end
