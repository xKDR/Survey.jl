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

julia> dclus1 = SurveyDesign(apiclus1; clusters=:dnum, weights=:pw)
SurveyDesign:
data: 183×44 DataFrame
strata: none
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
    function SurveyDesign(
        data::AbstractDataFrame;
        clusters::Union{Nothing,Symbol,Vector{Symbol}} = nothing,
        strata::Union{Nothing,Symbol} = nothing,
        popsize::Union{Nothing,Symbol} = nothing,
        weights::Union{Nothing,Symbol} = nothing,
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
            @warn "As part of single-stage approximation, only the first stage cluster ID is retained."
            cluster = first(clusters)
        end
        if typeof(clusters) <: Symbol
            cluster = clusters
        end
        # For single-stage approximation only one "effective" sampsize vector
        sampsize_labels = :_sampsize
        if isa(strata, Symbol) && isnothing(clusters) # If stratified only then sampsize is inside strata
            data[!, sampsize_labels] =
                transform(groupby(data, strata), nrow => :counts).counts
        else
            data[!, sampsize_labels] = fill(length(unique(data[!, cluster])), (nrow(data),))
        end

        if isa(weights, Symbol)
            if !(typeof(data[!, weights]) <: Vector{<:Real})
                throw(
                    ArgumentError(
                        string("given weights column ", weights, " is not of numeric type"),
                    ),
                )
            else
                # derive popsize from given `weights`
                weights_labels = weights
                popsize = :_popsize
                data[!, popsize] = data[!, sampsize_labels] .* data[!, weights_labels]
            end
        elseif isa(popsize, Symbol)
                weights_labels = :_weights
                data[!, weights_labels] = data[!, popsize] ./ data[!, sampsize_labels]
        else
            # neither popsize nor weights given
            weights_labels = :_weights
            data[!, weights_labels] = repeat([1], nrow(data))
            popsize = :_popsize
            data[!, popsize] = data[!, sampsize_labels] .* data[!, weights_labels]
        end
        allprobs_labels = :_allprobs
        data[!, allprobs_labels] = 1 ./ data[!, weights_labels] # In one-stage cluster sample, allprobs is just probs, no multiplication needed
        pps = false # for now no explicit pps supported faster functions, but they can be added
        new(
            data,
            cluster,
            popsize,
            sampsize_labels,
            strata,
            weights_labels,
            allprobs_labels,
            pps,
        )
    end
end

"""
    InferenceMethod

Abstract type for inference methods.
"""
abstract type InferenceMethod end

"""
    BootstrapReplicates <: InferenceMethod

Type for the bootstrap replicates method. For more details, see [`bootweights`](@ref).
"""
struct BootstrapReplicates <: InferenceMethod
    replicates::UInt
end

"""
    JackknifeReplicates <: InferenceMethod

Type for the Jackknife replicates method. For more details, see [`jackknifeweights`](@ref).
"""
struct JackknifeReplicates <: InferenceMethod
    replicates::UInt
end

"""
    ReplicateDesign <: AbstractSurveyDesign

Survey design obtained by replicating an original design using an inference method like [`bootweights`](@ref) or [`jackknifeweights`](@ref). If
replicate weights are available, then they can be used to directly create a `ReplicateDesign` object.

# Constructors

```julia
ReplicateDesign{ReplicateType}(
    data::AbstractDataFrame,
    replicate_weights::Vector{Symbol};
    clusters::Union{Nothing,Symbol,Vector{Symbol}} = nothing,
    strata::Union{Nothing,Symbol} = nothing,
    popsize::Union{Nothing,Symbol} = nothing,
    weights::Union{Nothing,Symbol} = nothing
) where {ReplicateType <: InferenceMethod}

ReplicateDesign{ReplicateType}(
    data::AbstractDataFrame,
    replicate_weights::UnitIndex{Int};
    clusters::Union{Nothing,Symbol,Vector{Symbol}} = nothing,
    strata::Union{Nothing,Symbol} = nothing,
    popsize::Union{Nothing,Symbol} = nothing,
    weights::Union{Nothing,Symbol} = nothing
) where {ReplicateType <: InferenceMethod}

ReplicateDesign{ReplicateType}(
    data::AbstractDataFrame,
    replicate_weights::Regex;
    clusters::Union{Nothing,Symbol,Vector{Symbol}} = nothing,
    strata::Union{Nothing,Symbol} = nothing,
    popsize::Union{Nothing,Symbol} = nothing,
    weights::Union{Nothing,Symbol} = nothing
) where {ReplicateType <: InferenceMethod}
```

# Arguments

`ReplicateType` must be one of the supported inference types; currently the package supports [`BootstrapReplicates`](@ref) and [`JackknifeReplicates`](@ref). The constructor has the same arguments as [`SurveyDesign`](@ref). The only additional argument is `replicate_weights`, which can
be of one of the following types.

- `Vector{Symbol}`: In this case, each `Symbol` in the vector should represent a column of `data` containing the replicate weights.
- `UnitIndex{Int}`: For instance, this could be UnitRange(5:10). This will mean that the replicate weights are contained in columns 5 through 10.
- `Regex`: In this case, all the columns of `data` which match this `Regex` will be treated as the columns containing the replicate weights.

All the columns containing the replicate weights will be renamed to the form `replicate_i`, where `i` ranges from 1 to the number of columns containing the replicate weights.

# Examples

Here is an example where the [`bootweights`](@ref) function is used to create a `ReplicateDesign{BootstrapReplicates}`.

```jldoctest replicate-design; setup = :(using Survey, CSV, DataFrames)
julia> apistrat = load_data("apistrat");

julia> dstrat = SurveyDesign(apistrat; strata=:stype, weights=:pw);

julia> bootstrat = bootweights(dstrat; replicates=1000)     # creating a ReplicateDesign using bootweights
ReplicateDesign{BootstrapReplicates}:
data: 200×1044 DataFrame
strata: stype
    [E, E, E  …  H]
cluster: none
popsize: [4420.9999, 4420.9999, 4420.9999  …  755.0]
sampsize: [100, 100, 100  …  50]
weights: [44.21, 44.21, 44.21  …  15.1]
allprobs: [0.0226, 0.0226, 0.0226  …  0.0662]
type: bootstrap
replicates: 1000

```

If the replicate weights are given to us already, then we can directly pass them to the `ReplicateDesign` constructor. For instance, in
the above example, suppose we had the `bootstrat` data as a CSV file (for this example, we also rename the columns containing the replicate weights to the form `r_i`).

```jldoctest replicate-design
julia> using CSV;

julia> DataFrames.rename!(bootstrat.data, ["replicate_"*string(index) => "r_"*string(index) for index in 1:1000]);

julia> CSV.write("apistrat_withreplicates.csv", bootstrat.data);

```

We can now pass the replicate weights directly to the `ReplicateDesign` constructor, either as a `Vector{Symbol}`, a `UnitRange` or a `Regex`.

```jldoctest replicate-design
julia> bootstrat_direct = ReplicateDesign{BootstrapReplicates}(CSV.read("apistrat_withreplicates.csv", DataFrame), [Symbol("r_"*string(replicate)) for replicate in 1:1000]; strata=:stype, weights=:pw)
ReplicateDesign{BootstrapReplicates}:
data: 200×1044 DataFrame
strata: stype
    [E, E, E  …  H]
cluster: none
popsize: [4420.9999, 4420.9999, 4420.9999  …  755.0]
sampsize: [100, 100, 100  …  50]
weights: [44.21, 44.21, 44.21  …  15.1]
allprobs: [0.0226, 0.0226, 0.0226  …  0.0662]
type: bootstrap
replicates: 1000

julia> bootstrat_unitrange = ReplicateDesign{BootstrapReplicates}(CSV.read("apistrat_withreplicates.csv", DataFrame), UnitRange(45:1044);strata=:stype, weights=:pw)
ReplicateDesign{BootstrapReplicates}:
data: 200×1044 DataFrame
strata: stype
    [E, E, E  …  H]
cluster: none
popsize: [4420.9999, 4420.9999, 4420.9999  …  755.0]
sampsize: [100, 100, 100  …  50]
weights: [44.21, 44.21, 44.21  …  15.1]
allprobs: [0.0226, 0.0226, 0.0226  …  0.0662]
type: bootstrap
replicates: 1000

julia> bootstrat_regex = ReplicateDesign{BootstrapReplicates}(CSV.read("apistrat_withreplicates.csv", DataFrame), r"r_\\d";strata=:stype, weights=:pw)
ReplicateDesign{BootstrapReplicates}:
data: 200×1044 DataFrame
strata: stype
    [E, E, E  …  H]
cluster: none
popsize: [4420.9999, 4420.9999, 4420.9999  …  755.0]
sampsize: [100, 100, 100  …  50]
weights: [44.21, 44.21, 44.21  …  15.1]
allprobs: [0.0226, 0.0226, 0.0226  …  0.0662]
type: bootstrap
replicates: 1000

```

"""
struct ReplicateDesign{ReplicateType} <: AbstractSurveyDesign
    data::AbstractDataFrame
    cluster::Symbol
    popsize::Symbol
    sampsize::Symbol
    strata::Symbol
    weights::Symbol # Effective weights in case of singlestage approx supported
    allprobs::Symbol # Right now only singlestage approx supported
    pps::Bool
    type::String
    replicates::UInt
    replicate_weights::Vector{Symbol}
    inference_method::ReplicateType

    # default constructor
    function ReplicateDesign{ReplicateType}(
        data::DataFrame,
        cluster::Symbol,
        popsize::Symbol,
        sampsize::Symbol,
        strata::Symbol,
        weights::Symbol,
        allprobs::Symbol,
        pps::Bool,
        type::String,
        replicates::UInt,
        replicate_weights::Vector{Symbol},
    ) where {ReplicateType <: InferenceMethod}
        new{ReplicateType}(data, cluster, popsize, sampsize, strata, weights, allprobs,
           pps, type, replicates, replicate_weights, ReplicateType(replicates))
    end

    # constructor with given replicate_weights
    function ReplicateDesign{ReplicateType}(
        data::AbstractDataFrame,
        replicate_weights::Vector{Symbol};
        clusters::Union{Nothing,Symbol,Vector{Symbol}} = nothing,
        strata::Union{Nothing,Symbol} = nothing,
        popsize::Union{Nothing,Symbol} = nothing,
        weights::Union{Nothing,Symbol} = nothing
    ) where {ReplicateType <: InferenceMethod}
        # rename the replicate weights if needed
        rename!(data, [replicate_weights[index] => "replicate_"*string(index) for index in 1:length(replicate_weights)])

        # call the SurveyDesign constructor
        base_design = SurveyDesign(
                        data;
                        clusters=clusters,
                        strata=strata,
                        popsize=popsize,
                        weights=weights
                      )
        new{ReplicateType}(
            base_design.data,
            base_design.cluster,
            base_design.popsize,
            base_design.sampsize,
            base_design.strata,
            base_design.weights,
            base_design.allprobs,
            base_design.pps,
            "bootstrap",
            length(replicate_weights),
            replicate_weights,
            ReplicateType(length(replicate_weights))
        )
    end

    # replicate weights given as a range of columns
    ReplicateDesign{ReplicateType}(
        data::AbstractDataFrame,
        replicate_weights::UnitRange{Int};
        clusters::Union{Nothing,Symbol,Vector{Symbol}} = nothing,
        strata::Union{Nothing,Symbol} = nothing,
        popsize::Union{Nothing,Symbol} = nothing,
        weights::Union{Nothing,Symbol} = nothing
    ) where {ReplicateType <: InferenceMethod} =
        ReplicateDesign{ReplicateType}(
            data,
            Symbol.(names(data)[replicate_weights]);
            clusters=clusters,
            strata=strata,
            popsize=popsize,
            weights=weights
        )

    # replicate weights given as regular expression
    ReplicateDesign{ReplicateType}(
        data::AbstractDataFrame,
        replicate_weights::Regex;
        clusters::Union{Nothing,Symbol,Vector{Symbol}} = nothing,
        strata::Union{Nothing,Symbol} = nothing,
        popsize::Union{Nothing,Symbol} = nothing,
        weights::Union{Nothing,Symbol} = nothing
    ) where {ReplicateType <: InferenceMethod} =
        ReplicateDesign{ReplicateType}(
            data,
            Symbol.(names(data)[findall(name -> occursin(replicate_weights, name), names(data))]);
            clusters=clusters,
            strata=strata,
            popsize=popsize,
            weights=weights
        )
end
