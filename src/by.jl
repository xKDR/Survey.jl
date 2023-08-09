function subset(group, design::SurveyDesign)
    return SurveyDesign(DataFrame(group);clusters = design.cluster, strata = design.strata, popsize = design.popsize, weights = design.weights)   
end

function subset(group, design::ReplicateDesign{BootstrapReplicates})
    return ReplicateDesign{typeof(design.inference_method)}(DataFrame(group), design.replicate_weights;clusters = design.cluster, strata = design.strata, popsize = design.popsize, weights = design.weights)   
end

function bydomain(x::Union{Symbol, Vector{Symbol}}, domain,design::Union{SurveyDesign, ReplicateDesign{BootstrapReplicates}}, func::Function, args...; kwargs...)
    gdf = groupby(design.data, domain)
    vars = DataFrame[]
    for group in gdf
        push!(vars, func(x, subset(group, design), args...; kwargs...))
    end
    return vcat(vars...)
end