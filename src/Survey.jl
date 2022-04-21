module Survey

using DataFrames
using Statistics
using StatsBase

export svydesign
export svyby

struct svydesign
    ids::Symbol
    probs::Symbol
    strata::Symbol
    variables::Symbol
    fpc::Symbol
    data::DataFrame
    nest::Bool
    check_strat::Bool
    weights::Symbol 
    svydesign(; data = DataFrame(), ids = Symbol(), probs = Symbol(), strata = Symbol(), variables = Symbol(), fpc = Symbol(), nest = false, check_strat = false, weights = Symbol()) = new(ids, probs, strata, variables, fpc, data, nest, check_strat, weights)
end

function svyby(;formula = Symbol(), by = Symbol(), design = svydesign(), func=mean, params = [])
    gdf = groupby(design.data, by)
    w = design.weights
    statistic = combine(gdf, [formula, w] => ((x, y) -> func(x, weights(y), params...)) => :stats)
    return statistic
end

function Base.show(io::IO, design::svydesign)
    printstyled("Survey Design:\n") 
    printstyled("data: "; bold = true)
    print(size(design.data)[1], "x", size(design.data)[2], " DataFrame")
    if length(string(design.weights)) > 0 
        printstyled("\nweights: "; bold = true)
        print(design.weights)
    end
    if length(string(design.ids)) > 0
        printstyled("\nid: "; bold = true)
        print(design.ids)
    end
    if length(string(design.strata)) > 0
        printstyled("\nid: "; bold = true)
        print(design.strata)
    end
    if length(string(design.variables)) > 0
        printstyled("\nid: "; bold = true)
        print(design.variables)
    end
    if length(string(design.fpc)) > 0
        printstyled("\nid: "; bold = true)
        print(design.fpc)
    end
    printstyled("\nnest: "; bold = true)
    print(design.nest)
    printstyled("\ncheck_strat: "; bold = true)
    print(design.check_strat)
end
# unstack(mean_income, :HR, :statistic)

end

