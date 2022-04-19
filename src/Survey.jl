module Survey

struct svydesign
    ids::Symbol
    probs
    strata::Symbol
    variables
    fpc
    data
    nest::Bool
    check_strat
    weights::Symbol
    svydesign(; ids = nothing, probs = nothing, strata = nothing, variables = nothing, fpc = nothing, data = nothing, nest = nothing, check_strat = nothing, weights = nothing) = new(ids, probs, strata, variables, fpc, data, nest, check_strat, weights)
end


function svyby(formula, by, design::svydesign, func, params)
    gdf = groupby(design.data, by)
    weights = design.weights
    statistic = combine(gdf, [formula, weights] => ((formula, weights) -> func(formula, weights(weights)), params...) => :statistic)
    return statistic
end

# unstack(mean_income, :HR, :statistic)

end
