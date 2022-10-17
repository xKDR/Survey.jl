# SimpleRandomSample

"""
Compute the mean of the survey variable `var`.

```jldoctest
julia> apisrs = load_data("apisrs");

julia> srs = SimpleRandomSample(apisrs);

julia> svymean(:enroll, srs)
1×2 DataFrame
 Row │ mean     sem
     │ Float64  Float64
─────┼──────────────────
   1 │  584.61  27.8212
```
"""
function var_of_mean(x::Symbol, design::SimpleRandomSample)
    return design.fpc ./ design.sampsize .* var(design.data[!, x])
end

"""
Inner method for `svyby`.
"""
function var_of_mean(x::AbstractVector, design::SimpleRandomSample)
    return design.fpc ./ design.sampsize .* var(x)
end

function sem(x::Symbol, design::SimpleRandomSample)
    return sqrt(var_of_mean(x, design))
end

"""
Inner method for `svyby`.
"""
function sem(x::AbstractVector, design::SimpleRandomSample)
    return sqrt(var_of_mean(x, design))
end

"""
    svymean(x, design)

Compute the mean and SEM of the variable `x`.
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
Inner method for `svyby`.
"""
function sem_svyby(x::AbstractVector, design::SimpleRandomSample, weights)
    N = sum(weights)
    Nd = length(x)
    Pd = Nd / N
    n = design.sampsize
    n̄d = n * Pd
    Ȳd = mean(x)
    S2d = var(x)
    Sd = sqrt(S2d)
    CVd = Sd / Ȳd
    V̂_Ȳd = ((1 ./ n̄d) - (1 ./ Nd)) * S2d * (1 + (1 - Pd) / CVd^2)
    return sqrt(V̂_Ȳd)
end

function svymean(x::AbstractVector, design::SimpleRandomSample, weights)
    return DataFrame(mean = mean(x), sem = sem_svyby(x, design::SimpleRandomSample, weights))
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