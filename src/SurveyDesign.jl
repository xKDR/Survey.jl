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
- `popsize::Union{Nothing, Symbol}=nothing`: the (expected) survey population size.

```jldoctest
julia> apiclus1 = load_data("apiclus1");

julia> dclus1 = SurveyDesign(apiclus1; clusters=:dnum, strata=:stype, weights=:pw)
SurveyDesign:
data: 183×43 DataFrame
strata: stype
    [H, E, E  …  E]
cluster: dnum
    [637, 637, 637  …  448]
popsize: [507.7049, 507.7049, 507.7049  …  507.7049]
sampsize: [15, 15, 15  …  15]
weights: [33.847, 33.847, 33.847  …  33.847]
allprobs: [0.0295, 0.0295, 0.0295  …  0.0295]
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
        # For single-stage approximation only one "effective" sampsize vector
        sampsize_labels = :sampsize
        if isa(strata,Symbol) && isnothing(clusters) # If stratified sample then sampsize is inside strata
            data[!, sampsize_labels] = transform(groupby(data, strata), nrow => :counts).counts
        else
            data[!, sampsize_labels] = fill(length(unique(data[!, cluster])), (nrow(data),))
        end
        if isa(popsize, Symbol)
            weights_labels = :weights
            data[!, weights_labels] = data[!, popsize] ./ data[!, sampsize_labels]
        elseif isa(weights, Symbol)
            if !(typeof(data[!, weights]) <: Vector{<:Real})
                throw(ArgumentError(string("given weights column ", weights , " is not of numeric type")))
            else
                weights_labels = weights
                # derive popsize from given `weights`
                popsize = :popsize
                data[!, popsize] = data[!, sampsize_labels] .* data[!, weights_labels]
            end
        else
            # neither popsize nor weights given
            weights_labels = :weights
            data[!, weights_labels] = repeat([1], nrow(data))
        end
        allprobs_labels = :allprobs
        data[!, allprobs_labels] = 1 ./ data[!, weights_labels] # In one-stage cluster sample, allprobs is just probs, no multiplication needed
        pps = false # for now no explicit pps supported faster functions, but they can be added
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
data: 200×1046 DataFrame
strata: stype
    [E, E, E  …  H]
cluster: none
popsize: [6190.0, 6190.0, 6190.0  …  6190.0]
sampsize: [200, 200, 200  …  200]
weights: [44.2, 44.2, 44.2  …  15.1]
probs: [0.0226, 0.0226, 0.0226  …  0.0662]
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
