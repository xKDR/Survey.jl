"""
    svyttest(y, group, design; level = 0.95)

Design-based two-sample t-test for the difference in the mean of `y` between the
two levels of the binary variable `group`, matching `svyttest` in the R `survey`
package. The difference is `mean(y in second level) - mean(y in first level)`,
with levels in sorted order (as for an R factor).

For a `SurveyDesign` the standard error of the difference is computed by Taylor
linearization; for a `ReplicateDesign` it is computed from the replicate weights.
The test uses a t distribution with `degf(design) - 1` degrees of freedom.

Returns a one-row `DataFrame` with the estimated difference, its standard error,
the t statistic, degrees of freedom, p-value and confidence interval.

```jldoctest; setup = :(using Survey)
julia> apisrs = load_data("apisrs");

julia> srs = SurveyDesign(apisrs; weights=:pw);

julia> svyttest(:api00, Symbol("comp.imp"), srs)
1×7 DataFrame
 Row │ estimate  SE       t        df     p_value     ci_lower  ci_upper
     │ Float64   Float64  Float64  Int64  Float64     Float64   Float64
─────┼───────────────────────────────────────────────────────────────────
   1 │  50.7955  18.5525  2.73794    198  0.00674597   14.2097   87.3813
```
"""
function svyttest(y::Symbol, group::Symbol, design::SurveyDesign; level::Real = 0.95)
    groups = sort!(unique(design.data[!, group]))
    length(groups) == 2 || throw(ArgumentError("group must be binary"))
    yvec = design.data[!, y]
    w = design.data[!, design.weights]
    indicator0 = design.data[!, group] .== groups[1]
    indicator1 = design.data[!, group] .== groups[2]
    N0 = sum(w .* indicator0)
    N1 = sum(w .* indicator1)
    μ0 = sum(w .* yvec .* indicator0) / N0
    μ1 = sum(w .* yvec .* indicator1) / N1
    difference = μ1 - μ0
    # influence function of the difference of the two domain means
    z = indicator1 .* (yvec .- μ1) ./ N1 .- indicator0 .* (yvec .- μ0) ./ N0
    se = _se_total(z, design)
    return _ttest_result(difference, se, degf(design) - 1, level)
end

function svyttest(y::Symbol, group::Symbol, design::ReplicateDesign; level::Real = 0.95)
    groups = sort!(unique(design.data[!, group]))
    length(groups) == 2 || throw(ArgumentError("group must be binary"))

    function inner_difference(df::DataFrame, columns, weights_column)
        yvec = df[!, columns[1]]
        w = df[!, weights_column]
        indicator0 = df[!, columns[2]] .== groups[1]
        indicator1 = df[!, columns[2]] .== groups[2]
        μ0 = sum(w .* yvec .* indicator0) / sum(w .* indicator0)
        μ1 = sum(w .* yvec .* indicator1) / sum(w .* indicator1)
        return μ1 - μ0
    end

    df = standarderror([y, group], inner_difference, design)
    return _ttest_result(df.estimator[1], df.SE[1], degf(design) - 1, level)
end

function _ttest_result(difference, se, dof, level)
    t = difference / se
    p = 2 * ccdf(TDist(dof), abs(t))
    q = quantile(TDist(dof), 1 - (1 - level) / 2)
    return DataFrame(
        estimate = difference,
        SE = se,
        t = t,
        df = dof,
        p_value = p,
        ci_lower = difference - q * se,
        ci_upper = difference + q * se,
    )
end
