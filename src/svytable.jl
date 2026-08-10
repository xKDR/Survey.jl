"""
    svytable(design, vars...; Ntotal = nothing)

Estimated population contingency table of one or more categorical variables: the
sum of sampling weights in each cell, matching `svytable` in the R `survey`
package. The result is a `DataFrame` in long format with one row per cell (zero
cells included) and a `Freq` column.

If `Ntotal` is given, the table is scaled to sum to `Ntotal` (as used, for
example, in the Rao-Scott chi-square test).

```jldoctest; setup = :(using Survey)
julia> apistrat = load_data("apistrat");

julia> dstrat = SurveyDesign(apistrat; strata=:stype, weights=:pw);

julia> svytable(dstrat, :stype, :awards)
6×3 DataFrame
 Row │ stype    awards   Freq
     │ String1  String3  Float64
─────┼───────────────────────────
   1 │ E        No       1193.67
   2 │ E        Yes      3227.33
   3 │ H        No        513.4
   4 │ H        Yes       241.6
   5 │ M        No        529.36
   6 │ M        Yes       488.64
```
"""
function svytable(design::AbstractSurveyDesign, vars::Symbol...; Ntotal::Union{Nothing,Real} = nothing)
    isempty(vars) && throw(ArgumentError("at least one variable is required"))
    columns = collect(vars)
    tbl = combine(groupby(design.data, columns), design.weights => sum => :Freq)
    # complete the cross product of observed levels with zero cells, like xtabs
    full = reduce(
        crossjoin,
        [DataFrame(v => sort!(unique(design.data[!, v]))) for v in columns],
    )
    tbl = leftjoin(full, tbl, on = columns)
    tbl.Freq = coalesce.(tbl.Freq, 0.0)
    sort!(tbl, columns)
    if !isnothing(Ntotal)
        tbl.Freq .*= Ntotal / sum(tbl.Freq)
    end
    return tbl
end
