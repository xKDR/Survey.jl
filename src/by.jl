function subset(group, design::SurveyDesign)
    return SurveyDesign(DataFrame(group);clusters = design.cluster, strata = design.strata, popsize = design.popsize, weights = design.weights)
end

function subset(group, design::ReplicateDesign)
    return ReplicateDesign{typeof(design.inference_method)}(DataFrame(group), design.replicate_weights;clusters = design.cluster, strata = design.strata, popsize = design.popsize, weights = design.weights)
end

function _domain_names(gdf, domain)
    domain_names = [join(collect(keys(gdf)[i]), "-") for i = 1:length(gdf)]
    if isa(domain, Vector{Symbol})
        domain = join(domain, "_")
    end
    return domain_names, domain
end

function bydomain(x::Union{Symbol, Vector{Symbol}}, domain,design::Union{SurveyDesign, ReplicateDesign}, func::Function, args...; kwargs...)
    domain_names = unique(design.data[!, domain])
    gdf = groupby(design.data, domain)
    domain_names, domain = _domain_names(gdf, domain)
    vars = DataFrame[]
    for group in gdf
        push!(vars, func(x, subset(group, design), args...; kwargs...))
    end
    estimates = vcat(vars...)
    estimates[!, domain] = domain_names
    return estimates
end

# For a `SurveyDesign`, domain means, totals and ratios are estimated with
# linearized standard errors computed on the full design (via indicator
# variables), matching `svyby` in R. Subsetting the data and re-deriving the
# design (as the generic method above does) would produce incorrect design-based
# standard errors, because PSUs without domain members would be dropped.
function bydomain(
    x::Union{Symbol,Vector{Symbol}},
    domain,
    design::SurveyDesign,
    func::Union{typeof(mean),typeof(total),typeof(ratio)},
    args...;
    kwargs...,
)
    gdf = groupby(design.data, domain)
    domain_names, domain = _domain_names(gdf, domain)
    w = design.data[!, design.weights]
    n = nrow(design.data)
    estimates = Float64[]
    ses = Float64[]
    for group in gdf
        indicator = zeros(n)
        indicator[parentindices(group)[1]] .= 1.0
        if func === total
            y = design.data[!, x] .* indicator
            push!(estimates, sum(w .* y))
            push!(ses, _se_total(y, design))
        elseif func === mean
            y = design.data[!, x]
            Nd = sum(w .* indicator)
            μ = sum(w .* y .* indicator) / Nd
            push!(estimates, μ)
            push!(ses, _se_total(indicator .* (y .- μ) ./ Nd, design))
        else # ratio
            num = design.data[!, x[1]] .* indicator
            den = design.data[!, x[2]] .* indicator
            se, R = _se_ratio(num, den, design)
            push!(estimates, R)
            push!(ses, se)
        end
    end
    label = func === total ? :total : func === mean ? :mean : :ratio
    estimates = DataFrame(label => estimates, :SE => ses)
    estimates[!, domain] = domain_names
    return estimates
end
