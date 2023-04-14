"""
    mean(var, design)

Estimate the mean of a variable.

```jldoctest
julia> apiclus1 = load_data("apiclus1");

julia> dclus1 = SurveyDesign(apiclus1; clusters = :dnum, weights = :pw)
SurveyDesign:
data: 183×44 DataFrame
strata: none
cluster: dnum
    [637, 637, 637  …  448]
popsize: [507.7049, 507.7049, 507.7049  …  507.7049]
sampsize: [15, 15, 15  …  15]
weights: [33.847, 33.847, 33.847  …  33.847]
allprobs: [0.0295, 0.0295, 0.0295  …  0.0295]

julia> mean(:api00, dclus1)
1×1 DataFrame
 Row │ mean
     │ Float64
─────┼─────────
   1 │ 644.169 
```
"""
function mean(x::Symbol, design::SurveyDesign)
    X = mean(design.data[!, x], weights(design.data[!, design.weights]))
    DataFrame(mean = X)
end

"""

Use replicate weights to compute the standard error of the estimated mean. 

```jldoctest; setup = :(apiclus1 = load_data("apiclus1"); dclus1 = SurveyDesign(apiclus1; clusters = :dnum, weights = :pw))
julia> bclus1 = dclus1 |> bootweights;

julia> mean(:api00, bclus1)
1×2 DataFrame
 Row │ mean     SE
     │ Float64  Float64
─────┼──────────────────
   1 │ 644.169  23.4107
```
"""
function mean(x::Symbol, design::ReplicateDesign)
    if design.type == "bootstrap"
        θ̂ = mean(design.data[!, x], weights(design.data[!, design.weights]))
        θ̂t = [
            mean(design.data[!, x], weights(design.data[!, "replicate_"*string(i)])) for
            i = 1:design.replicates
        ]
        variance = sum((θ̂t .- θ̂) .^ 2) / design.replicates
        return DataFrame(mean = θ̂, SE = sqrt(variance))
    # Jackknife integration
    elseif design.type == "jackknife"
        weightedmean(x, y) = mean(x, weights(y))
        return jackknife_variance(x, weightedmean, design)
    end
end

"""
Estimate the mean of a list of variables.

```jldoctest meanlabel; setup = :(apiclus1 = load_data("apiclus1"); dclus1 = SurveyDesign(apiclus1; clusters = :dnum, weights = :pw); bclus1 = dclus1 |> bootweights)
julia> mean([:api00, :enroll], dclus1)
2×2 DataFrame
 Row │ names   mean
     │ String  Float64
─────┼─────────────────
   1 │ api00   644.169
   2 │ enroll  549.716
``` 

Use replicate weights to compute the standard error of the estimated means. 

```jldoctest meanlabel
julia> mean([:api00, :enroll], bclus1)
2×3 DataFrame
 Row │ names   mean     SE
     │ String  Float64  Float64
─────┼──────────────────────────
   1 │ api00   644.169  23.4107
   2 │ enroll  549.716  45.7835 
```
"""
function mean(x::Vector{Symbol}, design::AbstractSurveyDesign)
    df = reduce(vcat, [mean(i, design) for i in x])
    insertcols!(df, 1, :names => String.(x))
    return df
end

"""
    mean(var, domain, design)

Estimate means of domains.

```jldoctest meanlabel; setup = :(apiclus1 = load_data("apiclus1"); dclus1 = SurveyDesign(apiclus1; clusters = :dnum, weights = :pw); bclus1 = dclus1 |> bootweights)
julia> mean(:api00, :cname, dclus1)
11×2 DataFrame
 Row │ cname        mean
     │ String15     Float64
─────┼──────────────────────
   1 │ Alameda      669.0
   2 │ Fresno       472.0
   3 │ Kern         452.5
   4 │ Los Angeles  647.267
   5 │ Mendocino    623.25
   6 │ Merced       519.25
   7 │ Orange       710.563
   8 │ Plumas       709.556
   9 │ San Diego    659.436
  10 │ San Joaquin  551.189
  11 │ Santa Clara  732.077 
```
Use the replicate design to compute standard errors of the estimated means. 

```jldoctest meanlabel
julia> mean(:api00, :cname, bclus1)
11×3 DataFrame
 Row │ cname        mean     SE
     │ String15     Float64  Float64
─────┼────────────────────────────────────
   1 │ Santa Clara  732.077  58.2169
   2 │ San Diego    659.436   2.66703
   3 │ Merced       519.25    2.28936e-15
   4 │ Los Angeles  647.267  47.6233
   5 │ Orange       710.563   2.19826e-13
   6 │ Fresno       472.0     1.13687e-13
   7 │ Plumas       709.556   1.26058e-13
   8 │ Alameda      669.0     1.27527e-13
   9 │ San Joaquin  551.189   2.1791e-13
  10 │ Kern         452.5     0.0
  11 │ Mendocino    623.25    1.09545e-13
```
"""
function mean(x::Symbol, domain, design::AbstractSurveyDesign)
    weighted_mean(x, w) = mean(x, StatsBase.weights(w))
    df = bydomain(x, domain, design, weighted_mean)
    rename!(df, :statistic => :mean)
    return df
end

"""
    mean(x, design, ci_type; kwargs)
    mean(x, domain, design, ci_type; kwargs)

Confidence intervals for `mean`. Three options for ci_type:
```julia
ci_type="normal"    # use Normal distribution critical values
ci_type="t"         # use Student t distribution critical values
ci_type="margin"    # use margin of error
```

Mathematically, the confidence interval is the range
```math
\\left[\\bar{x} - critical value * SE , \\bar{x} + critical value * SE  \\right]
```

Keyword arguments for each type of CI
```julia
alpha         # Significance level. Confidence level is 100*(1 - alpha)%
dof           # Degrees of freedom when ci_type="t"
margin        # Margin of error when ci_type="margin"
```
Also works when `Vector{Symbol}` and `domain` are specified.
```julia
# TODO example
```
## External links
[Confidence intervals on Wikipedia](https://en.wikipedia.org/wiki/Confidence_interval)
"""
function mean(x::Symbol, design::ReplicateDesign, ci_type::String;
    alpha::Float64=0.05, dof::Int64=nrow(design.data)-1, margin::Float64=2.0)
    df_mean = mean(x, design)
    ci_lower, ci_upper = _ci(df_mean[!,1], df_mean[!,2], ci_type, alpha, dof, margin)
    df_mean[!,:ci_lower] = ci_lower
    df_mean[!,:ci_upper] = ci_upper
    return df_mean
end

function mean(x::Vector{Symbol}, design::ReplicateDesign, ci_type::String;
    alpha::Float64=0.05, dof::Int64=nrow(design.data)-1, margin::Float64=2.0)
    df_mean = mean(x, design)
    ci_lower, ci_upper = _ci(df_mean[!,2], df_mean[!,3], ci_type, alpha, dof, margin) # mean and SE are in 2nd and 3rd columns
    df_mean[!,:ci_lower] = ci_lower
    df_mean[!,:ci_upper] = ci_upper
    return df_mean
end

function mean(x::Symbol, domain::Symbol, design::ReplicateDesign, ci_type::String; 
    alpha::Float64=0.05, dof::Int64=nrow(design.data)-1, margin::Float64=2.0)
    df_mean = mean(x, domain, design)
    ci_lower, ci_upper = _ci(df_mean[!,2], df_mean[!,3], ci_type, alpha, dof, margin) # domain mean and SE are in 2nd and 3rd columns
    df_mean[!,:ci_lower] = ci_lower
    df_mean[!,:ci_upper] = ci_upper
    return df_mean
end