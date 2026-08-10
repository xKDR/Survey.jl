"""
    poststratify(design, strata_var, population)

Post-stratify a survey design so that the estimated population count of each
level of `strata_var` matches the known `population`, following `postStratify` in
the R `survey` package. `population` must be a `DataFrame` with a column named
like `strata_var` giving the levels and a `Freq` column giving the corresponding
population counts.

For a `SurveyDesign`, the sampling weights are multiplied within each
post-stratum by `Freq / estimated count`, and a new design is returned (weights
column `:_poststrat_weights`).

!!! note

    Linearized standard errors computed from a post-stratified `SurveyDesign`
    treat the adjusted weights as fixed and therefore do not include the
    variance reduction from post-stratification (they are conservative). For
    fully design-based standard errors, post-stratify a `ReplicateDesign`: each
    set of replicate weights is post-stratified separately, exactly as in R.

```jldoctest; setup = :(using Survey, DataFrames)
julia> apiclus1 = load_data("apiclus1");

julia> dclus1 = SurveyDesign(apiclus1; clusters=:dnum, weights=:pw);

julia> pop_types = DataFrame(stype = ["E", "H", "M"], Freq = [4421, 755, 1018]);

julia> ps = poststratify(dclus1, :stype, pop_types);

julia> total(:stype, ps).total
3-element Vector{Float64}:
 4420.999999999992
  755.0000000000001
 1017.9999999999998
```
"""
function poststratify(design::SurveyDesign, strata_var::Symbol, population::DataFrame)
    w = design.data[!, design.weights]
    g = _poststrat_multiplier(design.data[!, strata_var], w, population, strata_var)
    df = copy(design.data)
    df[!, :_poststrat_weights] = w .* g
    return SurveyDesign(
        df;
        clusters = design.cluster == :false_cluster ? nothing : design.cluster,
        strata = design.strata == :false_strata ? nothing : design.strata,
        weights = :_poststrat_weights,
    )
end

"""
    poststratify(design::ReplicateDesign, strata_var, population)

Post-stratify a replicate-weights design: the sampling weights and every set of
replicate weights are adjusted separately so that each reproduces the known
population counts, exactly as `postStratify` on a replicate design in R.
Standard errors computed from the result therefore reflect the
post-stratification.
"""
function poststratify(
    design::ReplicateDesign{ReplicateType},
    strata_var::Symbol,
    population::DataFrame,
) where {ReplicateType<:InferenceMethod}
    df = copy(design.data)
    cells = df[!, strata_var]
    w = df[!, design.weights]
    df[!, design.weights] =
        w .* _poststrat_multiplier(cells, w, population, strata_var)
    for replicate_column in design.replicate_weights
        rw = df[!, replicate_column]
        df[!, replicate_column] =
            rw .* _poststrat_multiplier(cells, rw, population, strata_var)
    end
    return ReplicateDesign{ReplicateType}(
        df,
        design.cluster,
        design.popsize,
        design.sampsize,
        design.strata,
        design.weights,
        design.allprobs,
        design.pps,
        design.type,
        design.replicates,
        design.replicate_weights,
        design.inference_method,
    )
end

# Per-observation multiplier Freq / (estimated cell count under weights `w`).
function _poststrat_multiplier(
    cells::AbstractVector,
    w::AbstractVector,
    population::DataFrame,
    strata_var::Symbol,
)
    String(strata_var) in names(population) || throw(
        ArgumentError("population must have a column named $(strata_var)"),
    )
    "Freq" in names(population) ||
        throw(ArgumentError("population must have a Freq column"))
    cell_totals = Dict{String,Float64}()
    for (cell, weight) in zip(cells, w)
        cell_totals[string(cell)] = get(cell_totals, string(cell), 0.0) + weight
    end
    population_totals = Dict(
        string(level) => Float64(freq) for
        (level, freq) in zip(population[!, strata_var], population.Freq)
    )
    for cell in keys(cell_totals)
        haskey(population_totals, cell) ||
            throw(ArgumentError("level $(cell) of $(strata_var) is absent from population"))
    end
    return [population_totals[string(cell)] / cell_totals[string(cell)] for cell in cells]
end

"""
    rake(design, margins, populations; maxit = 10, epsilon = 1)

Rake a survey design: iteratively post-stratify on each margin until the
estimated margin totals converge to the known population margins, following
`rake` in the R `survey` package. `margins` is a vector of variable names and
`populations` the corresponding vector of population `DataFrame`s (each with the
margin column and a `Freq` column, as for [`poststratify`](@ref)).

Works on both `SurveyDesign` (weights only; see the note in
[`poststratify`](@ref) about standard errors) and `ReplicateDesign` (all
replicate weights are raked, giving fully design-based standard errors).

`epsilon` is the convergence tolerance on the maximum absolute change in the
margin totals between iterations; values below 1 are interpreted as a fraction
of the total sampling weight, as in R.
"""
function rake(
    design::AbstractSurveyDesign,
    margins::Vector{Symbol},
    populations::Vector{DataFrame};
    maxit::Integer = 10,
    epsilon::Real = 1,
)
    length(margins) == length(populations) ||
        throw(ArgumentError("margins and populations do not match"))
    if epsilon < 1
        epsilon *= sum(design.data[!, design.weights])
    end
    oldtables = [_margin_totals(design, margin) for margin in margins]
    converged = false
    iterations = 0
    while iterations < maxit
        for (margin, population) in zip(margins, populations)
            design = poststratify(design, margin, population)
        end
        newtables = [_margin_totals(design, margin) for margin in margins]
        delta = maximum(
            maximum(abs.(new .- old)) for (new, old) in zip(newtables, oldtables)
        )
        if delta < epsilon
            converged = true
            break
        end
        oldtables = newtables
        iterations += 1
    end
    converged || @warn "Raking did not converge after $iterations iterations."
    return design
end

# Estimated population count of each (sorted) level of `margin`.
function _margin_totals(design::AbstractSurveyDesign, margin::Symbol)
    tbl = svytable(design, margin)
    return tbl.Freq
end
