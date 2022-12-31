"""
    mean(x, design)

Estimate the population mean of a variable of a simple random sample, and the corresponding standard error.

The calculations were done according to the book [Sampling Techniques](https://www.academia.edu/29684662/Cochran_1977_Sampling_Techniques_Third_Edition)
by William Cochran.

For SurveyDesign, formula adapted from Sarndal pg129, section 4.2.2 Simple Random Cluster Sampling

```jldoctest
julia> apisrs = load_data("apisrs");

julia> srs = SimpleRandomSample(apisrs;popsize=:fpc);

julia> mean(:enroll, srs)
1×2 DataFrame
 Row │ mean     SE     
     │ Float64  Float64 
─────┼──────────────────
   1 │  584.61  27.3684

julia> mean([:api00, :api99], srs)
2×3 DataFrame
 Row │ names   mean     SE     
     │ String  Float64  Float64 
─────┼──────────────────────────
   1 │ api00   656.585  9.24972
   2 │ api99   624.685  9.5003

julia> strat = load_data("apistrat"); 

julia> dstrat = StratifiedSample(strat, :stype; popsize  = :fpc); 

julia> mean(:api00, dstrat)
1×2 DataFrame
 Row │ mean     SE     
     │ Float64  Float64 
─────┼──────────────────
   1 │ 662.287  9.40894
```
"""
function mean(x::Symbol, design::SimpleRandomSample)
    function se(x::Symbol, design::SimpleRandomSample)
        variance = design.fpc * Statistics.var(design.data[!, x]) / design.sampsize 
        return sqrt(variance)
    end
    if isa(design.data[!, x], CategoricalArray)
        gdf = groupby(design.data, x)
        p = combine(gdf, nrow => :counts)
        p.mean = p.counts ./ sum(p.counts)
        # variance of proportion
        p.var = design.fpc .* p.mean .* (1 .- p.mean) ./ (design.sampsize - 1)
        p.se = sqrt.(p.var)
        return select(p, Not([:counts, :var]))
    end
    return DataFrame(mean=mean(design.data[!, x]), SE=se(x, design))
end

function mean(x::Vector{Symbol}, design::SimpleRandomSample)
    df = reduce(vcat, [mean(i, design) for i in x])
    insertcols!(df, 1, :names => String.(x))
    return df
end

function mean(x::Symbol, design::StratifiedSample)
    if x == design.strata
        gdf = groupby(design.data, x)
        p = combine(gdf, :weights => sum => :Nₕ)
        p.Wₕ = p.Nₕ ./ sum(p.Nₕ)
        p = select!(p, Not(:Nₕ))
        return p
    elseif isa(design.data[!, x], CategoricalArray)
        gdf = groupby(design.data, x)
        p = combine(gdf, nrow => :counts)
        p.proportion = p.counts ./ sum(p.counts)
        # variance of proportion
        p.var = design.fpc .* p.proportion .* (1 .- p.proportion) ./ (design.sampsize - 1)
        p.SE = sqrt.(p.var)
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
    return DataFrame(mean=Ȳ̂, SE=SE)
end

function mean(x::Symbol, design::SurveyDesign)
    ## Based on logical translation of corresponding in total.jl
    ## Not quite same from R as it rounds of `total`, so division results in difference
    # > svymean(~api00,dclus1)
    #     mean     SE
    # api00 644.17 23.542
    gdf = groupby(design.data, design.cluster)
    ȳₜ = combine(gdf, x => mean => :mean).mean
    Nₜ = first(design.data[!,design.popsize])
    nₜ = first(design.data[!,design.sampsize])
    Ȳ = mean(ȳₜ)
    s²ₜ = var(ȳₜ)
    VȲ = (1 - nₜ/Nₜ) * s²ₜ / nₜ
    return DataFrame(mean = Ȳ, SE = sqrt(VȲ))
end

"""
    mean(x, by, design)

Estimate the subpopulation mean of a variable `x`.

The calculations were done according to the book [Model-Assisted Survey Sampling](https://link.springer.com/book/9780387406206)
by Carl-Erik Sarndal, Bengt Swensson, Jan Wretman, section 3.3 and Chap 10. Assumes popsize is known and subpopulation size is unknown.

```jldoctest
julia> using Survey; 

julia> srs = load_data("apisrs"); 

julia> srs = SimpleRandomSample(srs; popsize = :fpc);

julia> mean(:api00, :cname, srs) |> first
DataFrameRow
 Row │ cname     mean     SE     
     │ String15  Float64  Float64 
─────┼────────────────────────────
   1 │ Kern        573.6  42.8026

julia> strat = load_data("apistrat");

julia> dstrat = StratifiedSample(strat, :stype; popsize  = :fpc);

julia> mean(:api00, :cname, dstrat) |> first 
DataFrameRow
 Row │ cname        mean     SE      
     │ String15     Float64  Float64 
─────┼───────────────────────────────
   1 │ Los Angeles  633.511  21.3912
```
"""
function mean(x::Symbol, by::Symbol, design::SimpleRandomSample) 
    function domain_mean(x::AbstractVector, design::SimpleRandomSample, weights)
        function se(x::AbstractVector, design::SimpleRandomSample)
            nd = length(x)  # domain size
            n = design.sampsize
            fpc = design.fpc
            variance = (nd / n)^(-2) / n * fpc * ((nd - 1) / (n - 1)) * var(x)
            return sqrt(variance)
        end
        return DataFrame(mean=Statistics.mean(x), SE=se(x, design))
    end
    gdf = groupby(design.data, by)
    combine(gdf, [x, :weights] => ((a, b) -> domain_mean(a, design, b)) => AsTable)
end

function mean(x::Symbol, by::Symbol, design::StratifiedSample)
    function domain_mean(x::AbstractVector, popsize::AbstractVector, sampsize::AbstractVector, sampfraction::AbstractVector, strata::AbstractVector)
        df = DataFrame(x=x, popsize=popsize, sampsize=sampsize, sampfraction=sampfraction, strata=strata)
        function calculate_components(x, popsize, sampsize, sampfraction)
            return DataFrame(
                nsdh = length(x),
                nsh = length(x),
                substrata_domain_totals = sum(x),
                ȳsdh = mean(x),
                Nh = first(popsize),
                nh = first(sampsize),
                fh = first(sampfraction),
                sigma_ȳsh_squares = sum((x .- mean(x)).^2)
                )
        end
        components = combine(groupby(df, :strata), [:x, :popsize, :sampsize, :sampfraction] => calculate_components => AsTable)
        domain_mean = sum(components.Nh .* components.substrata_domain_totals ./ components.nh) / sum(components.Nh .* components.nsdh ./ components.nh)
        pdh = components.nsdh ./ components.nh
        N̂d = sum(components.Nh .* pdh)
        domain_var = sum(components.Nh .^ 2 .* (1 .- components.fh) .* (components.sigma_ȳsh_squares .+ (components.nsdh .* (1 .- pdh) .* (components.ȳsdh .- domain_mean) .^ 2)) ./ (components.nh .* (components.nh .- 1))) ./ N̂d .^ 2
        domain_mean_se = sqrt(domain_var)
        return DataFrame(mean=domain_mean, SE=domain_mean_se)
    end
    gdf_domain = groupby(design.data, by)
    combine(gdf_domain, [x, :popsize,:sampsize,:sampfraction, design.strata] => domain_mean => AsTable)
end

"""
```jldoctest
julia> using Survey, Random, StatsBase; 

julia> apiclus1 = load_data("apiclus1"); 

julia> dclus1 = SurveyDesign(apiclus1, :dnum, :fpc); 

julia> mean(:api00, dclus1, Bootstrap(replicates = 1000, rng = MersenneTwister(111)))
1×2 DataFrame
 Row │ mean     SE      
     │ Float64  Float64 
─────┼──────────────────
   1 │ 644.169  23.0897
```
"""
function mean(x::Symbol, design::SurveyDesign, method::Bootstrap)
    weighted_mean(x, w) = mean(x, weights(w))
    df = bootstrap(x, design, weighted_mean; method.replicates, method.rng)
    df = rename(df, :statistic => :mean)
end

# function mean(x::Symbol, by::Symbol, design::SurveyDesign, method::Bootstrap)
#     gdf = groupby(design.data, by)
#     subdesigns = [SurveyDesign(gdf[i]; strata = design.strata, weights = :weights, clusters = design.cluster) for i in 1:length(gdf)]    
#     df = vcat([mean(x, subdesign, method) for subdesign in subdesigns]...)
#     df[!, by] = [first(gdf[i][!, by]) for i in 1:length(gdf)]
#     return df
# end

function mean(x::Symbol, design::ReplicateDesign)
    X = mean(design.data[!, x], weights(design.data.weights))
    Xt = [mean(design.data[!, x], weights(design.data.weights .* design.data[! , "replicate_"*string(i)])) for i in 1:design.replicates]
    variance = sum((Xt .- X).^2) / design.replicates
    DataFrame(mean = X, SE = sqrt(variance))
end


function mean(x::Symbol, domain::Symbol, design::ReplicateDesign)
    gdf = groupby(design.data, domain)
    X = combine(gdf, [x, :weights] => ((a, b) -> mean(a, weights(b))) => :mean)
    Xt_mat = Array{Float64, 2}(undef, (length(unique(design.data[!, domain])), design.replicates))
    for i in 1:design.replicates
        Xt = combine(gdf, [x, :weights, Symbol("replicate_"*string(i))] => ((a, b, c) -> mean(a, weights(b .* c))) => :mean).mean
        for i in 1:length(Xt)
            if isnan(Xt[i]) 
                Xt[i] = X.mean[i] # replace lonely psu with point estimate. This needs to be corrected. 
            end
        end
        Xt_mat[:, i] = Xt
    end
    X.SE = sqrt.(sum((Xt_mat .- X.mean).^2 / design.replicates, dims = 2))[:,1]
    return X
end