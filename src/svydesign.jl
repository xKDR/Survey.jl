"""
    svydesign

Type incorporating all necessary information to describe a survey design.
```
"""
struct svydesign
    id
    variables::DataFrame
    nest::Bool
    check_strat::Bool
end

function get_weights(data, wt::Vector)
    if nrow(data) == length(wt)
        return wt
    else
        @error "length of the weights vector is not equal to the number of rows in the dataset"
    end
end

function get_weights(data, wt::Nothing)
    return ones(nrow(data))
end

function get_weights(data, wt::Symbol)
    wt = data[!, String(wt)]
end

function get_probs(data, wt, probs::Symbol)
    return data[!, String(probs)]
end

function get_probs(data, wt, probs::Nothing)
    return 1 ./ wt
end

function get_fpc(data, fpc::Symbol)
    return data[!, String(fpc)]
end

function get_fpc(data, fpc::Nothing)
    return repeat([nothing], nrow(data))
end

function get_fpc(data, fpc::Vector)
    return fpc
end

function get_fpc(data, fpc::Real)
    return repeat([fpc], nrow(data))
end

function get_strata(data, strata::Symbol)
	return data[!, String(strata)]
end

function get_strata(data, strata::Vector)
	return strata
end

function get_strata(data, strata::Nothing)
	return repeat([1], nrow(data))
end

function svydesign(; data = DataFrame(), id = Symbol(), probs = nothing, strata = nothing, fpc = nothing, nest = false, check_strat = !nest, weights = nothing)
    wt = get_weights(data, weights)
    if isnothing(probs) & isnothing(weights)
        # THIS WARNING IS NOT NECESSARY
        @warn "No weights or probabilities supplied, assuming equal probability"
    end
    df = data
    df.probs = ProbabilityWeights(get_probs(data, wt, probs))
	df.weights = FrequencyWeights(get_weights(data, weights))
    df.popsize = get_fpc(data, fpc)
    df.sampsize = repeat([nrow(data)], nrow(data))
	df.strata = get_strata(data, strata)
    return svydesign(id, df, nest, check_strat)
end
