module Survey

struct svydesign
    ids
    probs
    strata
    variables
    fpc
    data
    nest
    check_strat
    weights
end

svydesign(; ids = nothing, probs = nothing, strata = nothing, variables = nothing, fpc = nothing, data = nothing, nest = nothing, check_strat = nothing, weights = nothing) = svydesign(ids, probs, strata, variables, fpc, data, nest, check_strat, weights)

function svyby(formula, by, design::svydesign, func, params)
    gdf = groupby(design.data, by)
    statistic = combine(gdf, [formula, design.weights] => ((formula, design.weights) -> func(formula, weights(design.weights)), params...) => :statistic)
    return statistic
end

# unstack(mean_income, :HR, :statistic)

end
