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
    mean(x, design)

Compute the mean and SEM of the survey variable `x`.

```jldoctest
julia> apisrs = load_data("apisrs");

julia> srs = SimpleRandomSample(apisrs;popsize=:fpc);

julia> mean(:enroll, srs)
1×2 DataFrame
 Row │ mean     sem     
     │ Float64  Float64 
─────┼──────────────────
   1 │  584.61  27.3684
```
"""
function mean(x::Symbol, design::SimpleRandomSample)
    if isa(design.data[!, x], CategoricalArray)
        gdf = groupby(design.data, x)
        p = combine(gdf, nrow => :counts)
        p.mean = p.counts ./ sum(p.counts)
        # variance of proportion
        p.var = design.fpc .* p.mean .* (1 .- p.mean) ./ (design.sampsize - 1)
        p.sem = sqrt.(p.var)
        return select(p, Not([:counts, :var]))
    end
    return DataFrame(mean=mean(design.data[!, x], dims=1), sem=sem(x, design))
end

function mean(x::Vector{Symbol}, design::SimpleRandomSample)
    means_list = []
    for i in x
        push!(means_list, mean(i, design))
    end
    df = reduce(vcat, means_list)
    insertcols!(df, 1, :names => String.(x))
    return df
end

"""
Inner method for `by`
"""
# Inner methods for `by`
function sem_by(x::AbstractVector, design::SimpleRandomSample)
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
Inner method for `by` for SimpleRandomSample
"""
function mean(x::AbstractVector, design::SimpleRandomSample, weights)
    return DataFrame(mean=Statistics.mean(x), sem=sem_by(x, design))
end

"""
Inner method for `by` for StratifiedSample
Calculates domain mean and its std error, based example 10.3.3 on pg394 Sarndal (1992)
"""
function mean(x::AbstractVector, popsize::AbstractVector, sampsize::AbstractVector, sampfraction::AbstractVector, strata::AbstractVector)
    df = DataFrame(x=x, popsize=popsize, sampsize=sampsize, sampfraction=sampfraction, strata=strata)
    nsdh = []
    substrata_domain_totals = []
    Nh = []
    nh = []
    fh = []
    ȳsdh = []
    sigma_ȳsh_squares = []
    grouped_frame = groupby(df, :strata)
    for each_strata in keys(grouped_frame)
        nsh = nrow(grouped_frame[each_strata])#, nrow=>:nsdh).nsdh
        push!(nsdh, nsh)
        substrata_domain_total = sum(grouped_frame[each_strata].x)
        ȳdh = Statistics.mean(grouped_frame[each_strata].x)
        push!(ȳsdh, ȳdh)
        push!(substrata_domain_totals, substrata_domain_total)
        popsizes = first(grouped_frame[each_strata].popsize)
        push!(Nh, popsizes)
        sampsizes = first(grouped_frame[each_strata].sampsize)
        push!(nh, sampsizes)
        sampfrac = first(grouped_frame[each_strata].sampfraction)
        push!(fh, sampfrac)
        push!(sigma_ȳsh_squares, sum((grouped_frame[each_strata].x .- ȳdh) .^ 2))
    end
    domain_mean = sum(Nh .* substrata_domain_totals ./ nh) / sum(Nh .* nsdh ./ nh)
    pdh = nsdh ./ nh
    N̂d = sum(Nh .* pdh)
    domain_var = sum(Nh .^ 2 .* (1 .- fh) .* (sigma_ȳsh_squares .+ (nsdh .* (1 .- pdh) .* (ȳsdh .- domain_mean) .^ 2)) ./ (nh .* (nh .- 1))) ./ N̂d .^ 2
    domain_mean_se = sqrt(domain_var)
    return DataFrame(domain_mean=domain_mean, domain_mean_se=domain_mean_se)
end

"""
    Survey mean for StratifiedSample objects.
    Ref: Cochran (1977)
"""
function mean(x::Symbol, design::StratifiedSample)
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
    return DataFrame(Ȳ̂=Ȳ̂, SE=SE)
end

function mean(::Bool; x::Symbol, design::StratifiedSample)
    gdf = groupby(design.data, design.strata)
    ȳₕ = combine(gdf, x => mean => :mean).mean
    s²ₕ = combine(gdf, x => var => :s²h).s²h
    return DataFrame(ȳₕ, s²ₕ)
end