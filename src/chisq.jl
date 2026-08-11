"""
    svychisq(design, rows, cols; statistic = :F)

Rao-Scott test of independence between two categorical variables, matching
`svychisq` in the R `survey` package.

The Pearson chi-square statistic is computed from the estimated population table
scaled to the sample size, and its distribution is adjusted for the design using
the matrix of design effects ``\\Delta`` estimated from the linearized covariance
of the cell proportions.

- `statistic = :F` (default): second-order Rao-Scott correction. Returns the F
  statistic ``X^2 / \\mathrm{tr}(\\Delta)`` with numerator degrees of freedom
  ``d_0 = \\mathrm{tr}(\\Delta)^2/\\mathrm{tr}(\\Delta^2)`` and denominator
  degrees of freedom ``d_0 \\nu``, where ``\\nu`` is [`degf`](@ref) of the design.
- `statistic = :Chisq`: first-order Rao-Scott correction. Returns the Pearson
  statistic with a p-value computed from a chi-square distribution for the
  statistic divided by the mean design effect.

Returns a one-row `DataFrame` with the statistic, degrees of freedom and p-value.

```jldoctest; setup = :(using Survey)
julia> apistrat = load_data("apistrat");

julia> dstrat = SurveyDesign(apistrat; strata=:stype, popsize=:fpc);

julia> svychisq(dstrat, :stype, :awards)
1×4 DataFrame
 Row │ statistic  ndf      ddf      p_value
     │ Float64    Float64  Float64  Float64
─────┼─────────────────────────────────────────
   1 │   14.1694  1.88514  371.372  2.08211e-6
```
"""
function svychisq(
    design::SurveyDesign,
    rows::Symbol,
    cols::Symbol;
    statistic::Symbol = :F,
)
    statistic in (:F, :Chisq) ||
        throw(ArgumentError("statistic must be :F or :Chisq"))
    row_levels = sort!(unique(design.data[!, rows]))
    col_levels = sort!(unique(design.data[!, cols]))
    nr = length(row_levels)
    nc = length(col_levels)
    n = nrow(design.data)
    w = design.data[!, design.weights]

    # cell indicator matrix; cells ordered with the row factor varying fastest,
    # as in R's interaction(factor(rows), factor(cols))
    row_index = Dict(level => i for (i, level) in enumerate(row_levels))
    col_index = Dict(level => i for (i, level) in enumerate(col_levels))
    mm = zeros(n, nr * nc)
    for i = 1:n
        cell = (col_index[design.data[i, cols]] - 1) * nr + row_index[design.data[i, rows]]
        mm[i, cell] = 1.0
    end

    # estimated cell proportions and their linearized covariance
    N = sum(w)
    props = vec(sum(w .* mm, dims = 1)) ./ N
    V = _vcov_totals((mm .- props') ./ N, design)

    # Pearson X^2 from the estimated table scaled to the sample size
    observed = reshape(props .* n, nr, nc)
    row_margins = vec(sum(observed, dims = 2))
    col_margins = vec(sum(observed, dims = 1))
    expected = (row_margins * col_margins') ./ n
    X2 = sum((observed .- expected) .^ 2 ./ expected)

    # main-effects and interaction design matrices on the grid of cells
    X1 = zeros(nr * nc, 1 + (nr - 1) + (nc - 1))
    X12 = zeros(nr * nc, (nr - 1) * (nc - 1))
    k = 0
    for c = 1:nc, r = 1:nr
        k += 1
        X1[k, 1] = 1.0
        r > 1 && (X1[k, 1+(r-1)] = 1.0)
        c > 1 && (X1[k, 1+(nr-1)+(c-1)] = 1.0)
        if r > 1 && c > 1
            X12[k, (c-2)*(nr-1)+(r-1)] = 1.0
        end
    end
    C = X12 .- X1 * (X1 \ X12)

    inverse_props = Diagonal([p == 0 ? 0.0 : 1 / p for p in props])
    denominator = C' * (inverse_props ./ n) * C
    numerator = C' * inverse_props * V * inverse_props * C
    Δ = denominator \ numerator
    trace = tr(Δ)
    ν = degf(design)

    if statistic == :F
        F = X2 / trace
        d0 = trace^2 / tr(Δ * Δ)
        p = ccdf(FDist(d0, d0 * ν), F)
        return DataFrame(statistic = F, ndf = d0, ddf = d0 * ν, p_value = p)
    else
        df_chisq = (nr - 1) * (nc - 1)
        p = ccdf(Chisq(df_chisq), X2 / (trace / df_chisq))
        return DataFrame(statistic = X2, df = df_chisq, p_value = p)
    end
end
