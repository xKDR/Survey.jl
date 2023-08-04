function bydomain(x::Symbol, domain, design::SurveyDesign, func::Function)
    gdf = groupby(design.data, domain)
    X = combine(gdf, [x, design.weights] => ((a, b) -> func(a, weights(b))) => :statistic)
    return X
end

function bydomain(x::Union{Symbol, Vector{Symbol}}, domain,design::ReplicateDesign{BootstrapReplicates}, func::Function, args...; kwargs...)
    gdf = groupby(design.data, domain)
    vars = DataFrame[]
    for group in gdf
        rep_domain = ReplicateDesign{typeof(design.inference_method)}(DataFrame(group), design.replicate_weights;clusters = design.cluster, strata = design.strata, popsize = design.popsize, weights = design.weights)   
        push!(vars, func(x, rep_domain))
    end
    return vcat(vars...)
end
