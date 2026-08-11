"""
    confint(estimate::DataFrame; level = 0.95, dof = nothing)

Compute confidence intervals for an estimate returned by [`mean`](@ref),
[`total`](@ref), [`ratio`](@ref), [`var`](@ref) or a domain estimator. The input
must contain an `SE` column; the column immediately preceding `SE` is taken as
the point estimate.

By default a normal (Wald) interval is computed, matching `confint` in the R
`survey` package. Passing `dof` (typically [`degf`](@ref) of the design) uses
quantiles of a t distribution instead, matching `confint(..., df = degf(design))`
in R.

```jldoctest; setup = :(using Survey)
julia> apisrs = load_data("apisrs");

julia> srs = SurveyDesign(apisrs; weights=:pw);

julia> confint(mean(:api00, srs))
1×4 DataFrame
 Row │ mean     SE       ci_lower  ci_upper
     │ Float64  Float64  Float64   Float64
─────┼──────────────────────────────────────
   1 │ 656.585  9.40277   638.156   675.014

julia> confint(mean(:api00, srs); dof = degf(srs))
1×4 DataFrame
 Row │ mean     SE       ci_lower  ci_upper
     │ Float64  Float64  Float64   Float64
─────┼──────────────────────────────────────
   1 │ 656.585  9.40277   638.043   675.127
```
"""
function confint(estimate::DataFrame; level::Real = 0.95, dof::Union{Nothing,Real} = nothing)
    se_index = findfirst(==("SE"), names(estimate))
    isnothing(se_index) && throw(
        ArgumentError("the estimate must contain an SE column to compute confidence intervals"),
    )
    se_index == 1 && throw(ArgumentError("no point estimate column found before the SE column"))
    est_column = names(estimate)[se_index-1]
    q =
        isnothing(dof) ? quantile(Normal(), 1 - (1 - level) / 2) :
        quantile(TDist(dof), 1 - (1 - level) / 2)
    out = copy(estimate)
    out[!, :ci_lower] = out[!, est_column] .- q .* out[!, :SE]
    out[!, :ci_upper] = out[!, est_column] .+ q .* out[!, :SE]
    return out
end
