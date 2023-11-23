function subset(group, design::SurveyDesign)
    return SurveyDesign(DataFrame(group);clusters = design.cluster, strata = design.strata, popsize = design.popsize, weights = design.weights)   
end 

function subset(group, design::ReplicateDesign)
    return ReplicateDesign{typeof(design.inference_method)}(DataFrame(group), design.replicate_weights;clusters = design.cluster, strata = design.strata, popsize = design.popsize, weights = design.weights)   
end

function bydomain(x::Union{Symbol, Vector{Symbol}}, domain,design::Union{SurveyDesign, ReplicateDesign}, func::Function, args...; kwargs...)
    domain_names = unique(design.data[!, domain])
    gdf = groupby(design.data, domain)
    domain_names = [join(collect(keys(gdf)[i]), "-") for i in 1:length(gdf)]
    vars = DataFrame[]
    for group in gdf
        push!(vars, func(x, subset(group, design), args...; kwargs...))
    end
    estimates = vcat(vars...)
    if isa(domain, Vector{Symbol})
        domain = join(domain, "_")
    end
    estimates[!, domain] = domain_names
    return estimates
end