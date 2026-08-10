"""
Internal helpers implementing Taylor linearization (the default variance method of
the R `survey` package) for `SurveyDesign` objects under the single-stage
approximation: stratified sampling of PSUs, where the PSUs are either clusters or
individual observations.
"""

# Group a vector into indices by value, preserving order of first appearance.
function _group_indices(v::AbstractVector)
    index = Dict{eltype(v),Int}()
    groups = Vector{Vector{Int}}()
    for (i, x) in enumerate(v)
        j = get!(index, x) do
            push!(groups, Int[])
            length(groups)
        end
        push!(groups[j], i)
    end
    return groups
end

"""
    _vcov_totals(Z, design)

Linearized (Taylor) covariance matrix of the Horvitz-Thompson total estimators of
the columns of `Z`. For stratum ``h`` with ``n_h`` sampled PSUs and cluster totals
``t_{hj} = \\sum_{i \\in \\text{psu } j} w_i z_i``,

```math
\\hat{V} = \\sum_h (1 - f_h) \\dfrac{n_h}{n_h - 1} \\sum_j (t_{hj} - \\bar{t}_h)(t_{hj} - \\bar{t}_h)^T
```

where ``f_h = n_h/N_h`` is the sampling fraction if the design was constructed
with an explicit `popsize` (finite population correction), and ``f_h = 0``
otherwise (with-replacement approximation). PSUs are always nested within strata,
so cluster identifiers may be reused across strata.
"""
function _vcov_totals(Z::AbstractMatrix{<:Real}, design::SurveyDesign)
    df = design.data
    w = df[!, design.weights]
    p = size(Z, 2)
    V = zeros(p, p)
    for stratum_rows in _group_indices(df[!, design.strata])
        psus = _group_indices(view(df[!, design.cluster], stratum_rows))
        nh = length(psus)
        if nh == 1
            throw(
                ArgumentError(
                    "stratum with a single PSU encountered: the linearized variance is undefined",
                ),
            )
        end
        # cluster totals of w .* z within the stratum
        T = zeros(nh, p)
        for (j, psu_rows) in enumerate(psus)
            for i in psu_rows
                row = stratum_rows[i]
                for k = 1:p
                    T[j, k] += w[row] * Z[row, k]
                end
            end
        end
        tbar = vec(sum(T, dims = 1)) ./ nh
        fh = design.has_fpc ? nh / df[stratum_rows[1], design.popsize] : 0.0
        scale = (1 - fh) * nh / (nh - 1)
        for j = 1:nh, a = 1:p, b = 1:p
            V[a, b] += scale * (T[j, a] - tbar[a]) * (T[j, b] - tbar[b])
        end
    end
    return V
end

_variance_total(z::AbstractVector{<:Real}, design::SurveyDesign) =
    _vcov_totals(reshape(z, :, 1), design)[1, 1]

_se_total(z::AbstractVector{<:Real}, design::SurveyDesign) =
    sqrt(_variance_total(z, design))

# Linearized SE of the ratio of the totals of `num` and `den`:
# influence z_i = (num_i - R̂ den_i) / Ŷ_den
function _se_ratio(
    num::AbstractVector{<:Real},
    den::AbstractVector{<:Real},
    design::SurveyDesign,
)
    w = design.data[!, design.weights]
    Y = sum(w .* den)
    R = sum(w .* num) / Y
    return _se_total((num .- R .* den) ./ Y, design), R
end

# Linearized SE of the weighted mean of `y`: special case of the ratio estimator
# with denominator 1.
function _se_mean(y::AbstractVector{<:Real}, design::SurveyDesign)
    w = design.data[!, design.weights]
    N = sum(w)
    μ = sum(w .* y) / N
    return _se_total((y .- μ) ./ N, design), μ
end

"""
    degf(design)

Degrees of freedom of a survey design: the number of PSUs minus the number of
strata (matching `degf` in the R `survey` package). Used for t-based confidence
intervals and tests.

```jldoctest; setup = :(using Survey)
julia> apistrat = load_data("apistrat");

julia> dstrat = SurveyDesign(apistrat; strata=:stype, weights=:pw);

julia> degf(dstrat)
197
```
"""
function degf(design::AbstractSurveyDesign)
    df = design.data
    strata = df[!, design.strata]
    npsus = sum(length(_group_indices(view(df[!, design.cluster], rows)))
                for rows in _group_indices(strata))
    return npsus - length(unique(strata))
end

# Detect columns that should be treated like R factors: anything non-numeric,
# e.g. strings or CategoricalArrays.
_iscategorical(col::AbstractVector) = !(eltype(col) <: Union{Missing,Real})
