"""
    AbstractSurveyDesign

Supertype for every survey design type. 

!!! note

    The data passed to a survey constructor is modified. To avoid this pass a copy of the data
    instead of the original.
"""
abstract type AbstractSurveyDesign end

"""
    SurveyDesign <: AbstractSurveyDesign

General survey design encompassing a simple random, stratified, cluster or multi-stage design.

In the case of cluster sample, the clusters are chosen by simple random sampling. All
individuals in one cluster are sampled. The clusters are considered disjoint and nested.

`strata` and `clusters` must be given as columns in `data`.

# Arguments:
- `data::AbstractDataFrame`: the survey dataset (!this gets modified by the constructor).
- `strata::Union{Nothing, Symbol}=nothing`: the stratification variable.
- `clusters::Union{Nothing, Symbol, Vector{Symbol}}=nothing`: the clustering variable.
- `weights::Union{Nothing, Symbol}=nothing`: the sampling weights.
- `popsize::Union{Nothing, Int, Symbol}=nothing`: the (expected) survey population size.

```jldoctest
julia> apiclus1 = load_data("apiclus1");

julia> dclus1 = SurveyDesign(apiclus1; clusters=:dnum, weights=:pw)
SurveyDesign:
data: 183x44 DataFrame
cluster: dnum
design.data[!,design.cluster]: 637, 637, 637, ..., 448
popsize: popsize
design.data[!,design.popsize]: 6190.0, 6190.0, 6190.0, ..., 6190.0
sampsize: sampsize
design.data[!,design.sampsize]: 15, 15, 15, ..., 15
design.data[!,design.allprobs]: 0.0198, 0.0198, 0.0198, ..., 0.0198
```
"""
struct SurveyDesign <: AbstractSurveyDesign
    data::AbstractDataFrame
    cluster::Symbol
    popsize::Symbol
    sampsize::Symbol
    strata::Symbol
    weights::Symbol # Effective weights in case of singlestage approx supported
    allprobs::Symbol # Right now only singlestage approx supported
    pps::Bool # TODO functionality
    # Single stage clusters sample, like apiclus1
    function SurveyDesign(data::AbstractDataFrame;
        clusters::Union{Nothing,Symbol,Vector{Symbol}}=nothing,
        strata::Union{Nothing,Symbol}=nothing,
        popsize::Union{Nothing,Symbol}=nothing,
        weights::Union{Nothing,Symbol}=nothing
    )
        # sampsize here is number of clusters completely sampled, popsize is total clusters in population
        if typeof(strata) <: Nothing
            data.false_strata = repeat(["FALSE_STRATA"], nrow(data))
            strata = :false_strata
        end
        if typeof(clusters) <: Nothing
            data.false_cluster = 1:nrow(data)
            cluster = :false_cluster
        end
        ## Single stage approximation
        if typeof(clusters) <: Vector{Symbol}
            cluster = first(clusters)
        end
        if typeof(clusters) <: Symbol
            cluster = clusters
        end
        # For one-stage sample only one sampsize vector
        sampsize_labels = :sampsize
        data[!, sampsize_labels] = fill(length(unique(data[!, cluster])), (nrow(data),))
        if !(typeof(popsize) <: Nothing)
            weights_labels = :weights
            data[!, weights_labels] = data[!, popsize] ./ data[!, sampsize_labels]
        elseif typeof(weights) <: Symbol
            if !(typeof(data[!, weights]) <: Vector{<:Real})
                error(string("given weights column ", weights , " is not of numeric type"))
            end
            weights_labels = weights
        else
            weights_labels = :weights
            data[!, weights_labels] = repeat([1], nrow(data))
        end
        allprobs_labels = :allprobs
        data[!, allprobs_labels] = 1 ./ data[!, weights_labels] # In one-stage cluster sample, allprobs is just probs, no multiplication needed
        pps = false # for now no explicit pps support
        if !(typeof(popsize) <: Symbol)
            popsize = :popsize
            data[!,popsize] = repeat([sum(data[!, weights_labels])], nrow(data))
        end
        new(data, cluster, popsize, sampsize_labels, strata, weights_labels, allprobs_labels, pps)
    end
end

"""
    ReplicateDesign <: AbstractSurveyDesign

Survey design obtained by replicating an original design using [`bootweights`](@ref).

```jldoctest
julia> apistrat = load_data("apistrat");

julia> strat = SurveyDesign(apistrat; strata=:stype, weights=:pw);

julia> bootstrat = bootweights(strat; replicates=1000)
ReplicateDesign:
data: 200x1046 DataFrame
cluster: false_cluster
design.data[!,design.cluster]: 1, 2, 3, ..., 200
popsize: popsize
design.data[!,design.popsize]: 6190.0, 6190.0, 6190.0, ..., 6190.0
sampsize: sampsize
design.data[!,design.sampsize]: 200, 200, 200, ..., 200
design.data[!,:probs]: 0.0226, 0.0226, 0.0226, ..., 0.0662
design.data[!,:allprobs]: 0.0226, 0.0226, 0.0226, ..., 0.0662
replicates: 1000
```
"""
struct ReplicateDesign <: AbstractSurveyDesign
    data::AbstractDataFrame
    cluster::Symbol
    popsize::Symbol
    sampsize::Symbol
    strata::Symbol
    pps::Bool
    replicates::UInt
end
