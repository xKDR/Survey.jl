# SimpleRandomSample

function var_of_total(x::Symbol, design::SimpleRandomSample)
    return design.popsize^2 * design.fpc * var(design.data[!, x]) / design.sampsize
end

function var_of_total(x::AbstractVector, design::SimpleRandomSample)
    return design.popsize^2 * design.fpc / design.sampsize * var(x)
end

function se_tot(x::Symbol, design::SimpleRandomSample)
    return sqrt(var_of_total(x, design))
end

"""
    total(x, design)

Estimate the population total for the variable specified by `x`.

```jldoctest
julia> apisrs = load_data("apisrs");

julia> srs = SimpleRandomSample(apisrs;popsize=:fpc);

julia> total(:enroll, srs)
1×2 DataFrame
 Row │ total      se_total 
     │ Float64    Float64  
─────┼─────────────────────
   1 │ 3.62107e6  1.6952e5
```
"""
function total(x::Symbol, design::SimpleRandomSample)
    if isa(design.data[!, x], CategoricalArray)
        gdf = groupby(design.data, x)
        p = combine(gdf, nrow => :count)
        p.total = design.popsize .* p.count ./ sum(p.count)
        p.proportion = p.total ./ design.popsize
        p = select!(p, Not(:count)) # count column is not necessary for `total`
        p.var = design.popsize^2 .* design.fpc .* p.proportion .*
                (1 .- p.proportion) ./ (design.sampsize - 1) # N^2 .* variance of proportion
        p.se_tot = sqrt.(p.var)
        return select(p, Not([:proportion, :var]))
    end
    m = mean(x,design)
    total = design.popsize * m.mean[1]
    return DataFrame(total=total, se_total=se_tot(x, design))
end

"""
Inner methods for `by`
"""
function se_total_by(x::AbstractVector, design::SimpleRandomSample, _)
    # vector of length equal to `sampsize` containing `x` and zeros
    z = cat(zeros(design.sampsize - length(x)), x; dims=1)
    # variance of the total
    variance = design.popsize^2 / design.sampsize * design.fpc * var(z)
    # return the standard error
    return sqrt(variance)
end

function total(x::AbstractVector, design::SimpleRandomSample, weights)
    total = wsum(x, weights)
    return DataFrame(total=total, sem=se_total_by(x, design::SimpleRandomSample, weights))
end

"""
total for StratifiedSample
"""

function total(x::Symbol, design::StratifiedSample)
    # TODO: check if statement
    if x == design.strata
        gdf = groupby(design.data, x)
        return combine(gdf, :weights => sum => :Nₕ)
    end
    gdf = groupby(design.data, design.strata)
    grand_total = sum(combine(gdf, [x, :weights] => ((a, b) -> wsum(a, b)) => :total).total) # works
    # variance estimation using closed-form formula
    ȳₕ = combine(gdf, x => mean => :mean).mean
    Nₕ = combine(gdf, :weights => sum => :Nₕ).Nₕ
    nₕ = combine(gdf, nrow => :nₕ).nₕ
    fₕ = nₕ ./ Nₕ
    Wₕ = Nₕ ./ sum(Nₕ)
    Ȳ̂ = sum(Wₕ .* ȳₕ)

    s²ₕ = combine(gdf, x => var => :s²h).s²h
    # the only difference between total and mean variance is the Nₕ instead of Wₕ
    V̂Ȳ̂ = sum((Nₕ .^ 2) .* (1 .- fₕ) .* s²ₕ ./ nₕ)
    SE = sqrt(V̂Ȳ̂)
    return DataFrame(grand_total=grand_total, SE=SE)
end

"""
Vectorise total operation over Vector{Symbol}
"""
function total(x::Vector{Symbol}, design::AbstractSurveyDesign)
    totals_list = []
    for i in x
        push!(totals_list, total(i, design))
    end
    df = reduce(vcat, totals_list)
    insertcols!(df, 1, :names => String.(x))
    return df
end