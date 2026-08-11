"""
    trimweights(design; lower = -Inf, upper = Inf, strict = false)

Trim sampling weights to the interval `[lower, upper]`, redistributing the
trimmed excess equally among the untrimmed observations, exactly as
`trimWeights` in the R `survey` package. With `strict = false` (the default) the
redistribution may push some weights over the bounds; `strict = true` repeats the
trimming until all weights are within bounds (or no weights remain to absorb the
excess, in which case a warning is emitted).

Returns a new `SurveyDesign` whose weights column (`:_trimmed_weights`) contains
the trimmed weights. The population size is re-derived from the trimmed weights.

```jldoctest; setup = :(using Survey)
julia> apistrat = load_data("apistrat");

julia> dstrat = SurveyDesign(apistrat; strata=:stype, weights=:pw);

julia> trimmed = trimweights(dstrat; upper = 40);

julia> sort(unique(round.(trimmed.data[!, trimmed.weights], digits=4)))
3-element Vector{Float64}:
 19.31
 24.57
 40.0
```
"""
function trimweights(
    design::SurveyDesign;
    lower::Real = -Inf,
    upper::Real = Inf,
    strict::Bool = false,
)
    pw = Vector{Float64}(design.data[!, design.weights])
    has_trimmed = falses(length(pw))
    outside = (pw .< lower) .| (pw .> upper)
    while any(outside)
        pw, has_trimmed = _do_trimweights(pw, lower, upper, has_trimmed)
        strict || break
        outside = (pw .< lower) .| (pw .> upper)
    end
    df = copy(design.data)
    df[!, :_trimmed_weights] = pw
    return SurveyDesign(
        df;
        clusters = design.cluster == :false_cluster ? nothing : design.cluster,
        strata = design.strata == :false_strata ? nothing : design.strata,
        weights = :_trimmed_weights,
    )
end

# One round of trimming: clamp the weights outside the bounds and spread the
# excess equally over observations that have not been trimmed before.
function _do_trimweights(pw, lower, upper, has_trimmed)
    outside = (pw .< lower) .| (pw .> upper)
    any(outside) || return pw, has_trimmed
    pwnew = clamp.(pw, lower, upper)
    trimmings = pw .- pwnew
    can_trim = .!outside .& .!has_trimmed
    if !any(can_trim)
        @warn "trimming failed"
    else
        pwnew[can_trim] .+= sum(trimmings) / count(can_trim)
    end
    return pwnew, outside .| has_trimmed
end
