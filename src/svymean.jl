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

function sem(x, design::SimpleRandomSample)
    return sqrt(var_of_mean(x, design))
end

"""
Inner method for `svyby`.
"""
function sem(x::AbstractVector, design::SimpleRandomSample)
    return sqrt(var_of_mean(x, design))
end

function svymean(x::Symbol, design::SimpleRandomSample)
    # Support behaviour like R for CategoricalArray type data
    if isa(x,Symbol) && isa(design.data[!,x], CategoricalArray)
        gdf = groupby(design.data, x)
        p = combine(gdf, nrow => :counts )
        p.proportion = p.counts ./ sum(p.counts)
        p.var = design.fpc .* p.proportion .* (1 .- p.proportion) ./ (design.sampsize - 1) # Formula for variance of proportion
        p.se = sqrt.(p.var)
        return p
    end
    return DataFrame(mean = mean(design.data[!, x]), sem = sem(x, design::SimpleRandomSample))
end

function svymean(x::Vector{Symbol}, design::SimpleRandomSample)
    means_list = []
    for i in x
        push!(means_list, svymean(i,design))
    end
    df = reduce(vcat, means_list)
    insertcols!(df,1, :names => String.(x))
    return df
end

"""
Inner method for `svyby`.
"""

function sem_svyby(x::AbstractVector, design::SimpleRandomSample, weights)
    # return sqrt( (1 - length(x)/design.popsize) ./ length(x) .* var(x) ) .*  sqrt(1 - 1 / length(x) + 1 / design.sampsize)
    # f =  sqrt()
    # pweights = 1 ./ design.data.prob
    # N = sum(design.data.weights)
    # Nd = sum(weights)
    # Nd = length(x)
    N = sum(weights)
    Nd = length(x)
    Pd = Nd/N
    n = design.sampsize
    n̄d = n * Pd
    Ȳd = mean(x)
    S2d = var(x)
    Sd = sqrt(S2d)
    CVd = Sd / Ȳd
    @show(N,Nd,Pd,n,n̄d,Ȳd,S2d,Sd,CVd)
    @show((1 ./ n̄d - 1 ./Nd ))
    V̂_Ȳd = ((1 ./ n̄d) - (1 ./Nd) ) * S2d * (1 + (1 - Pd) /  CVd^2 )
    print(V̂_Ȳd)
    print("\n")
    # print(V̂_Ȳd,"\n")
    return sqrt(V̂_Ȳd)
end
    # vsrs = var_of_mean(x, design)
    

    # vsrs2 = vsrs .* (psum-length(x)) ./ psum
    # return sqrt(vsrs2)
    # return sqrt( (1 - 1 / length(x) + 1 / design.sampsize) .* var(x) ./ length(x) ) 

# TODO: results not matching for `sem`
function svymean(x::AbstractVector , design::SimpleRandomSample, weights)
    return DataFrame(mean = mean(x), sem = sem_svyby(x, design::SimpleRandomSample, weights))
end

""" mean for Categorical variables 
"""

"""
StratifiedSample functions
"""

# function svymean(x::, design::SimpleRandomSample)
#     return DataFrame(mean = mean(design.data[!, x]), sem = sem(x, design::SimpleRandomSample))
# end
# function strata_sample_variance(y)
#     1 / ()
# end
function svymean(x::Symbol, design::StratifiedSample)
    # Support behaviour like R for CategoricalArray type data
    print("Yolo")
    if x == design.strata
        gdf = groupby(design.data, x)
        # nₕ = combine(gdf, nrow => :counts )
        p = combine(gdf, :weights => sum => :Nₕ )
        p.Wₕ = p.Nₕ ./ sum(p.Nₕ)
        p = select!(p, Not(:Nₕ))
        # p.proportion = p.counts ./ sum(p.counts)
        # @show nₕ , Nₕ , Wₕ
        return p 
    elseif isa(x,Symbol) && isa(design.data[!,x], CategoricalArray)
        print("Yolo")
        gdf = groupby(design.data, x)
        p = combine(gdf, nrow => :counts )
        # @show p
        p.proportion = p.counts ./ sum(p.counts)
        p.var = design.fpc .* p.proportion .* (1 .- p.proportion) ./ (design.sampsize - 1) # Formula for variance of proportion
        p.se = sqrt.(p.var)
        return p
    end
    gdf = groupby(design.data,design.strata)
    
    ȳₕ = combine(gdf, x => mean => :mean).mean
    Nₕ = combine(gdf, :weights => sum => :Nₕ ).Nₕ
    nₕ = combine(gdf, nrow => :nₕ).nₕ
    fₕ = nₕ ./ Nₕ
    Wₕ = Nₕ ./ sum(Nₕ)
    Ȳ̂ = sum(Wₕ .* ȳₕ)
    # Ȳ̂ = mean(ȳₕ, Wₕ ) # Is also correct 

    s²ₕ = combine(gdf, x => var => :s²h ).s²h
    V̂Ȳ̂ = sum( (Wₕ .^2) .* (1 .- fₕ) .* s²ₕ ./ nₕ )
    SE = sqrt(V̂Ȳ̂)
    
    # @show nₕ , Nₕ , fₕ , ȳₕ , Wₕ , Ȳ̂ , s²ₕ
    return DataFrame(Ȳ̂ = Ȳ̂ , SE = SE) # , sem = sem(x, design::SimpleRandomSample))
end