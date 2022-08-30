# Helper function for nice printing
function print_short(x)
    # write floats in short form
    if isa(x[1], Float64)
        x = round.(x, sigdigits = 3)
    end
    # print short vectors or single values as they are, compress otherwise
    if length(x) < 3
        print(x)
    else
        print( x[1], ", ", x[2], ", ", x[3], " ... ", last(x))
    end
end

"""
Supertype for every survey design type: `SimpleRandomSample`, `ClusterSample`
and `StratifiedSample`.

The data to a survey constructor is modified. To avoid this pass a copy of the data
instead of the original.
"""
abstract type AbstractSurveyDesign end

# N = pop_size
# n = sample_size
# In SRS, sampling weights, weightsᵢ = 1 / πᵢ = N/n
# Sampling fraction (aka 'probs') = f = πᵢ = n/N = 1 / weightsᵢ
# If pop_size N is not given, then N estimated using N̂ = n * weightsᵢ = n / πᵢ, typecasted to Int
# Variance of variable x, s²ₓ = 1/ (n-1) * Σ(xᵢ - x̄)²
# Variance of x̄ in SRS, V̂(x̄) = (1-n/N) * s²ₓ / n
# SE of x̄ in SRS = sqrt(V̂(x̄))
"""
    SimpleRandomSample <: AbstractSurveyDesign

Survey design sampled by simple random sampling.

The population size is equal to the sample size unless `popsize` is explicitly provided.
"""
struct SimpleRandomSample <: AbstractSurveyDesign
    data::DataFrame
    sampsize::UInt
    popsize::Union{UInt,Nothing}
    sampfraction::Real
    fpc::Real
    ignorefpc::Bool
    function SimpleRandomSample(data::DataFrame;
                                popsize = nothing,
                                sampsize = nrow(data),
                                weights = ones(nrow(data)), # Check the defaults
                                probs = nothing,
                                ignorefpc = true
                                )
        if isa(weights, Symbol)
            weights = data[!, weights]
        end
        # set population size if it is not given; `weights` and `sampsize` must be given
        if isnothing(popsize)
            popsize = round(sum(weights)) |> UInt
        end
        # add frequency weights column to `data`
        data[!, :weights] = weights
        # add probability weights column to `data`
        data[!, :probs] = 1 ./ data[!, :weights]
        # set sampling fraction
        sampfraction = sampsize / popsize
        # set fpc
        fpc = ignorefpc ? 1 : 1 - (sampsize / popsize)

        new(data, sampsize, popsize, sampfraction, fpc, ignorefpc)
    end
end

# `show` method for printing information about a `SimpleRandomSample` after construction
function Base.show(io::IO, ::MIME"text/plain", design::SimpleRandomSample)
    printstyled("Simple Random Sample:\n"; bold = true)
    printstyled("data: "; bold = true)
    print(size(design.data, 1), "x", size(design.data, 2), " DataFrame")
    printstyled("\nweights: "; bold = true)
    print_short(design.data.weights)
    printstyled("\nprobs: "; bold = true)
    print_short(design.data.probs)
    printstyled("\nfpc: "; bold = true)
    print_short(design.fpc)
    printstyled("\n    popsize: "; bold = true)
    print(design.popsize)
    printstyled("\n    sampsize: "; bold = true)
    print(design.sampsize)
end

"""
    StratifiedSample <: AbstractSurveyDesign

Survey design sampled by stratification.
"""
struct StratifiedSample <: AbstractSurveyDesign
    data::DataFrame
    sampsize::UInt
    popsize::Union{UInt,Nothing}
    sampfraction::Real
    fpc::Real
    nofpc::Bool
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
function Base.show(io::IO, design::StratifiedSample)
    printstyled("Stratified Sample:\n"; bold = true)
    printstyled("data: "; bold = true)
    print(size(design.data, 1), "x", size(design.data, 2), " DataFrame")
    printstyled("\nweights: "; bold = true)
    print_short(design.data.weights)
    printstyled("\nprobs: "; bold = true)
    print_short(design.data.probs)
    printstyled("\nstrata: "; bold = true)
    print_short(design.data.strata)
    printstyled("\nfpc: "; bold = true)
    print_short(design.fpc)
    printstyled("\n    popsize: "; bold = true)
    print(design.popsize)
    printstyled("\n    sampsize: "; bold = true)
    print(design.sampsize)
end

"""
    ClusterSample <: AbstractSurveyDesign

Survey design sampled by clustering.
"""
struct ClusterSample <: AbstractSurveyDesign
    data::DataFrame
end

# `show` method for printing information about a `ClusterSample` after construction
function Base.show(io::IO, design::ClusterSample)
    printstyled("Cluster Sample:\n"; bold = true)
    printstyled("data: "; bold = true)
    print(size(design.data, 1), "x", size(design.data, 2), " DataFrame")
    printstyled("\nweights: "; bold = true)
    print_short(design.data.weights)
    printstyled("\nprobs: "; bold = true)
    print_short(design.data.probs)
    printstyled("\nfpc: "; bold = true)
    print_short(design.fpc)
    printstyled("\n    popsize: "; bold = true)
    print(design.popsize)
    printstyled("\n    sampsize: "; bold = true)
    print(design.sampsize)
end
