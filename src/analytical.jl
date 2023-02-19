"""
    Variance under Simple Random Sampling scheme
    see Lohr pg78.
"""
function srs_variance(x::Symbol, design::AbstractSurveyDesign)
    ŝ = var(design.data[!,x]) ./ nrow(design.data)
    X̂ = wsum(design.data[!, x], weights(design.data[!, design.weights]))
    DataFrame(ht_total = X̂)
end

"""
    Strata totals
"""
function strata_totals(x::Symbol, design::AbstractSurveyDesign)
    gdf_strata = groupby(design.data, design.strata)
    X̂ₛ = combine(gdf_strata, [x, design.weights] => ((a, b) -> wsum(a, b)) => :total)
    return X̂ₛ
end