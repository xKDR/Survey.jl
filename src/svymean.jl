# SimpleRandomSample

"""
    var_of_mean(x, design)

Compute the variance of the mean for the variable `x`.
"""
function var_of_mean(x::Symbol, design::SimpleRandomSample)
    return design.fpc ./ design.sampsize .* var(design.data[!, x])
end

function var_of_mean(x::AbstractVector, design::SimpleRandomSample)
    return design.fpc ./ design.sampsize .* var(x)
end

"""
    sem(x, design)

Compute the standard error of the mean for the variable `x`.
"""
function sem(x::Symbol, design::SimpleRandomSample)
    return sqrt(var_of_mean(x, design))
end

function sem(x::AbstractVector, design::SimpleRandomSample)
    return sqrt(var_of_mean(x, design))
end

"""
    svymean(x, design)

Compute the mean and SEM of the survey variable `x`.

```jldoctest
julia> apisrs = load_data("apisrs");

julia> srs = SimpleRandomSample(apisrs; weights = :pw);

julia> svymean(:enroll, srs)
1×2 DataFrame
 Row │ mean     sem     
     │ Float64  Float64 
─────┼──────────────────
   1 │  584.61  27.3684
```
"""
function svymean(x::Symbol, design::SimpleRandomSample)
    if isa(x, Symbol) && isa(design.data[!, x], CategoricalArray)
        gdf = groupby(design.data, x)
        p = combine(gdf, nrow => :counts)
        p.proportion = p.counts ./ sum(p.counts)
        # variance of proportion
        p.var = design.fpc .* p.proportion .* (1 .- p.proportion) ./ (design.sampsize - 1)
        p.se = sqrt.(p.var)
        return p
    end
    return DataFrame(mean = mean(design.data[!, x]), sem = sem(x, design::SimpleRandomSample))
end

function svymean(x::Vector{Symbol}, design::SimpleRandomSample)
    means_list = []
    for i in x
        push!(means_list, svymean(i, design))
    end
    df = reduce(vcat, means_list)
    insertcols!(df, 1, :names => String.(x))
    return df
end

"""
Inner method for `svyby` to calculate standard error of domain mean of SimpleRandomSample.
"""
function sem_svyby(x::AbstractVector, design::SimpleRandomSample)
    # domain size
    dsize = length(x)
    # sample size
    ssize = design.sampsize
    # fpc
    fpc = design.fpc
    # variance of the mean
    variance = (dsize / ssize)^(-2) / ssize * fpc * ((dsize - 1) / (ssize - 1)) * var(x)
    # return the standard error
    return sqrt(variance)
end

"""
Inner method for `svyby` to calculate standard error of domain mean of StratifiedSample.
"""
function sem_svyby(x::AbstractVector, design::StratifiedSample,weights)
    # TODO placeholder
    SE = 0
    return SE
end

"""
    Domain mean estimator for StratifiedSample
    Adapted from Example 10.3.3 pg 394 of Sarndal et al. Model-Assisted Survey Sampling (1992)
"""
function domain_mean_stratified(design::SimpleRandomSample,gdf,formula)
    # Calculate strata sampling sampsize and popsize
    # TODO: if Nₕ and nₕ being used a lot, then add them to design object?
    Nₕ = design.Nₕ
    nₕ = design.nₕ
    # x is api00 within the domain

    # Only need nsdh and sigma_sdh_yk
    gdf_domain = gdf
    each_domain = keys(gdf_domain) # THIS IS A HACK, think about it
    domain_means = []
    
    # for each_domain in keys(gdf_domain)
    grouped_frame = groupby(gdf_domain[each_domain],design.strata)
    ############ How to get 0 as nrow of empty groupedframe
    nsdh = combine(grouped_frame, nrow=>:nsdh).nsdh # Lol this is not always length H!! sometimes strata empty in a domain
    # nsdh = combine(grouped_frame, :weights => length => :nsdh).nsdh
    ############
    @show nsdh
    substrata_domain_totals = combine(grouped_frame, formula => sum => :sigma_sdh_yk).sigma_sdh_yk
    @show substrata_domain_totals, nsdh

    domain_mean_estimator = sum(Nₕ .* substrata_domain_totals ./ nₕ ) / sum(Nₕ .* nsdh ./ nₕ)
    push!(domain_means,domain_mean_estimator)
    return domain_means
end

"""
Inner method for `svyby` for SimpleRandomSample
"""
function svymean(x::AbstractVector, design::SimpleRandomSample, weights)
    return DataFrame(mean = mean(x), sem = sem_svyby(x, design))
end

"""
Inner method for `svyby` for StratifiedSample
"""
function svymean(formula_vector::AbstractVector, design::StratifiedSample, weights, params)
    gdf,formula,by = params
    return DataFrame(mean = domain_mean_stratified(design,weights,gdf,formula,by),
                     sem = sem_svyby(formula_vector, design, weights))
end

# StratifiedSample

function svymean(x::Symbol, design::StratifiedSample)
    if x == design.strata
        gdf = groupby(design.data, x)
        p = combine(gdf, :weights => sum => :Nₕ)
        p.Wₕ = p.Nₕ ./ sum(p.Nₕ)
        p = select!(p, Not(:Nₕ))
        return p
    elseif isa(x, Symbol) && isa(design.data[!, x], CategoricalArray)
        gdf = groupby(design.data, x)
        p = combine(gdf, nrow => :counts)
        p.proportion = p.counts ./ sum(p.counts)
        # variance of proportion
        p.var = design.fpc .* p.proportion .* (1 .- p.proportion) ./ (design.sampsize - 1)
        p.se = sqrt.(p.var)
        return p
    end
    gdf = groupby(design.data, design.strata)

    ȳₕ = combine(gdf, x => mean => :mean).mean
    Nₕ = combine(gdf, :weights => sum => :Nₕ).Nₕ
    nₕ = combine(gdf, nrow => :nₕ).nₕ
    fₕ = nₕ ./ Nₕ
    Wₕ = Nₕ ./ sum(Nₕ)
    Ȳ̂ = sum(Wₕ .* ȳₕ)

    s²ₕ = combine(gdf, x => var => :s²h).s²h
    V̂Ȳ̂ = sum((Wₕ .^ 2) .* (1 .- fₕ) .* s²ₕ ./ nₕ)
    SE = sqrt(V̂Ȳ̂)

    return DataFrame(Ȳ̂ = Ȳ̂, SE = SE)
end