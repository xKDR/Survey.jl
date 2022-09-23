"""
    svytotal(x, design)

Estimate the population total for the variable specified by `x`.

```jldoctest
julia> apisrs = load_data("apisrs");

julia> srs = SimpleRandomSample(apisrs);

julia> svytotal(:enroll, srs)
1×2 DataFrame
 Row │ total     se_total
     │ Float64   Float64
─────┼────────────────────
   1 │ 116922.0   5564.24
```
"""
function var_of_total(x::Symbol, design::SimpleRandomSample)
    return design.popsize^2 * design.fpc * var(design.data[!, x]) / design.sampsize 
end

"""
Inner method for `svyby`.
"""
function var_of_total(x::AbstractVector, design::SimpleRandomSample)
    return design.popsize^2 * design.fpc / design.sampsize * var(x)
end

function se_tot(x::Symbol, design::SimpleRandomSample)
    return sqrt(var_of_total(x, design))
end

# function total(x::Symbol, design::SimpleRandomSample)
#     return wsum(design.data[!, x] , weights(design.data.weights)  )
# end

function svytotal(x::Symbol, design::SimpleRandomSample)
    # Support behaviour like R for CategoricalArray type data
    if isa(x,Symbol) && isa(design.data[!,x], CategoricalArray)
        gdf = groupby(design.data, x)
        p = combine(gdf, nrow => :count )
        p.total = design.popsize .* p.count ./ sum(p.count)
        p.proportion = p.total ./ design.popsize
        p = select!(p, Not(:count)) # Drop the count column as not really desired for svytotal
        p.var = design.popsize^2 .* design.fpc .* p.proportion .* (1 .- p.proportion) ./ (design.sampsize - 1) # N^2 .* Formula for variance of proportion
        p.se = sqrt.(p.var)
        return p
    end
    total = design.popsize * mean(design.data[!, x]) # This also returns correct answer and is more simpler to understand than wsum
    # total = wsum(design.data[!, x] , design.data.weights  )
    return DataFrame(total = total , se_total = se_tot(x, design::SimpleRandomSample))
end

# function svytotal(x::Symbol, design::svydesign)
#     # TODO
# end

function svytotal(x::Symbol, design::StratifiedSample)
    # # Support behaviour like R for CategoricalArray type data
    # if isa(x,Symbol) && isa(design.data[!,x], CategoricalArray)
    #     gdf = groupby(design.data, x)
    #     p = combine(gdf, nrow => :count )
    #     p.total = design.popsize .* p.count ./ sum(p.count)
    #     p.proportion = p.total ./ design.popsize
    #     p = select!(p, Not(:count)) # Drop the count column as not really desired for svytotal
    #     p.var = design.popsize^2 .* design.fpc .* p.proportion .* (1 .- p.proportion) ./ (design.sampsize - 1) # N^2 .* Formula for variance of proportion
    #     p.se = sqrt.(p.var)
    #     return p
    # end
    gdf = groupby(design.data,design.strata)
    # wsum(design.data[!, x] , weights(design.data.weights)  )
    grand_total = sum(combine(gdf, [x,:weights] => ( (a,b) -> wsum(a,b) ) => :total).total)
    # grand_total = wsum( combine(gdf, x => mean => :mean).mean, weights(combine(gdf, :weights => sum => :Nₕ ).Nₕ ) )
    return DataFrame(grand_total = grand_total) # , sem = sem(x, design::SimpleRandomSample))
end
