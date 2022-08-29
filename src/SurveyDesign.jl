# Helper function for nice printing
function print_short(x::AbstractVector)
    if length(x) < 3
        print(x)
    else
        print( x[1], ", ", x[2], ", ", x[3], " ... ", last(x))
    end
end

"""
    AbstractSurveyDesign

Supertype for survey designs. `SimpleRandomSample`, `ClusterSample`
and `StratifiedSample` are subtypes of this.

!!! note
    When passing data to a survey design, the user should make a copy of the
    data. The constructors modify the data passed as argument.
"""
abstract type AbstractSurveyDesign end

"""
    SimpleRandomSample

A `SimpleRandomSample` object contains survey design information needed to
analyse simple random sample surveys.
TODO: add fpc
By default popsize is same sampsize, unless explicitly provided
"""
struct SimpleRandomSample <: AbstractSurveyDesign
    data::DataFrame
    sample_size::Int
    pop_size::Int
    function SimpleRandomSample(data::DataFrame; sample_size = nrow(data), pop_size = nrow(data),
                                weights = ones(nrow(data)), probs = 1 ./ weights)
        # add frequency weights, probability weights and sample size columns
        # TODO: make lines 28 & 29 use a helper function?
        data[!, :weights] = weights
        data[!, :probs] = probs

        new(data, sample_size, pop_size)
    end
end

# `show` method for printing information about a `SimpleRandomSample` after construction
function Base.show(io::IO, ::MIME"text/plain", design::SimpleRandomSample)
    printstyled("Simple Random Sample:\n"; bold = true)
    printstyled("data: "; bold = true)
    print(size(design.data)[1], "x", size(design.data)[2], " DataFrame")
    printstyled("\nprobs: "; bold = true)
    print_short(design.data.probs)
    # TODO: change fpc
    printstyled("\nfpc: "; bold = true)
    print("\n    popsize: ")
    print(design.pop_size)
    print("\n    sampsize: ")
    print(design.sample_size)
end

"""
A `StratifiedSample` object holds information necessary for surveys sampled by
stratification.
"""
struct StratifiedSample <: AbstractSurveyDesign
    data::DataFrame
    function StratifiedSample(data::DataFrame, strata::AbstractVector; weights = ones(nrow(data)), probs = 1 ./ weights)
        # add frequency weights, probability weights and sample size columns
        data[!, :weights] = weights
        data[!, :probs] = probs
        # TODO: change `sampsize` and `popsize`
        data[!, :popsize] = repeat([nrow(data)], nrow(data))
        data[!, :sampsize] = repeat([nrow(data)], nrow(data))
        data[!, :strata] = strata

        new(data)
    end
end

# `show` method for printing information about a `StratifiedSample` after construction
function Base.show(io::IO, ::MIME"text/plain", design::StratifiedSample)
    printstyled("Stratified Sample:\n"; bold = true)
    printstyled("data: "; bold = true)
    print(size(design.data)[1], "x", size(design.data)[2], " DataFrame")
    printstyled("\nprobs: "; bold = true)
    print_short(design.data.probs)
    printstyled("\nstrata: "; bold = true)
    print_short(design.data.strata)
    # TODO: change fpc
    printstyled("\nfpc: "; bold = true)
    printstyled("\n    popsize: "; bold = true)
    print_short(design.data.popsize)
    printstyled("\n    sampsize: "; bold = true)
    print_short(design.data.sampsize)
end

"""
A `ClusterSample` object holds information necessary for surveys sampled by
clustering.
"""
struct ClusterSample <: AbstractSurveyDesign
    data::DataFrame
    function ClusterSample(data::DataFrame, id::Symbol; weights = ones(nrow(data)), probs = 1 ./ weights)
        # add frequency weights, probability weights and sample size columns
        data[!, :weights] = weights
        data[!, :probs] = probs
        # TODO: change `sampsize` and `popsize`
        data[!, :popsize] = repeat([nrow(data)], nrow(data))
        data[!, :sampsize] = repeat([nrow(data)], nrow(data))
        data[!, :id] = data[!, id]

        new(data)
    end
end

# `show` method for printing information about a `ClusterSample` after construction
function Base.show(io::IO, ::MIME"text/plain", design::ClusterSample)
    printstyled("Simple Random Sample:\n"; bold = true)
    printstyled("data: "; bold = true)
    print(size(design.data)[1], "x", size(design.data)[2], " DataFrame")
    printstyled("\nprobs: "; bold = true)
    print_short(design.data.probs)
    printstyled("\nid: "; bold = true)
    print_short(design.data.id)
    # TODO: change fpc
    printstyled("\nfpc: "; bold = true)
    printstyled("\n    popsize: "; bold = true)
    print_short(design.data.popsize)
    printstyled("\n    sampsize: "; bold = true)
    print_short(design.data.sampsize)
end
