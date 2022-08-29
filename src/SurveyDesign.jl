# Helper function for nice printing
function print_short(x::AbstractVector)
    if length(x) < 3
        print(x)
    else
        print( x[1], ", ", x[2], ", ", x[3], " ...", " (length = ", length(x), ")")
    end
end

"""
Supertype for every survey design type: `SimpleRandomSample`, `ClusterSample`
and `StratifiedSample`.
"""
abstract type AbstractSurveyDesign end

"""
A `SimpleRandomSample` object contains survey design information needed to
analyse surveys sampled by simple random sampling.
TODO: documentation about user making a copy
TODO: add fpc
By default popsize is same sampsize, unless explicitly provided .... hmmm

N = pop_size
n = sample_size
In SRS, sampling weights, weightsᵢ = 1 / πᵢ = N/n
Sampling fraction (aka 'probs') = f = πᵢ = n/N = 1 / weightsᵢ
If pop_size N is not given, then N estimated using N̂ = n * weightsᵢ = n / πᵢ, typecasted to Int
Variance of variable x, s²ₓ = 1/ (n-1) * Σ(xᵢ - x̄)²     
Variance of x̄ in SRS, V̂(x̄) = (1-n/N) * s²ₓ / n
SE of x̄ in SRS = sqrt(V̂(x̄))
"""
struct SimpleRandomSample <: AbstractSurveyDesign
    data::DataFrame
    sample_size::UInt
    pop_size::Union{UInt,Nothing}
    samplingFraction::Real
    fpc::Real
    ignorefpc::Bool
    function SimpleRandomSample(
        data::DataFrame,
        pop_size = nothing ; 
        sample_size = nrow(data), 
        weights = ones(nrow(data)), # Check the defaults 
        probs = nothing ,
        ignorefpc = false
        )
        # Set pop_size
        if isnothing(pop_size)
            # If they are not given
            pop_size = round( sum(weights)) |> UInt
        end
        # Else it is given
        # add frequency weights, probability weights and sample size columns
        # TODO: make lines 28 & 29 use a helper function?
        if typeof(weights) == Symbol
            data[!, :weights] = data.weights
        else
            data[!, :weights] = weights
        end
        # = 1 ./ weights
        data[!, :probs] = 1 ./ data[!, :weights]
        # If pop_size given, then use it to get samplingFraction
        samplingFraction = sample_size / pop_size
        # Elif pop_size not given, then weights and sample_size must be given,
        # So estimate pop_size N̂ = sample_size * Σ weights 
        # If user says to ignore fpc, then set it to 1, else calc it and continue as normal
        if ignorefpc
            fpc = 1
        else
            fpc = 1 - (sample_size / pop_size)
        end
        new(data, sample_size, pop_size, samplingFraction, fpc, ignorefpc )
    end
end

# `show` method for printing information about a `SimpleRandomSample` after construction
# TODO: change `show` to 3 argument method
function Base.show(io::IO, design::SimpleRandomSample)
    printstyled("Simple Random Sample:\n")
    printstyled("data: "; bold = true)
    print(size(design.data)[1], "x", size(design.data)[2], " DataFrame")
    printstyled("\nprobs: "; bold = true)
    print_short(design.data.probs)
    # TODO: change fpc
    printstyled("\nfpc: "; bold = true)
    print_short(design.fpc)
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
    sample_size::UInt
    pop_size::UInt
    samplingFraction::Float64
    fpc::Float64
    ignorefpc::Bool
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
    printstyled("Stratified Sample:\n")
    printstyled("data: "; bold = true)
    print(size(design.data)[1], "x", size(design.data)[2], " DataFrame")
    printstyled("\nprobs: "; bold = true)
    print_short(design.data.probs)
    printstyled("\nstrata: "; bold = true)
    print_short(design.data.strata)
    # TODO: change fpc
    printstyled("\nfpc: "; bold = true)
    print("\n    popsize: ")
    print_short(design.data.popsize)
    print("\n    sampsize: ")
    print_short(design.data.sampsize)
end

"""
A `ClusterSample` object holds information necessary for surveys sampled by
clustering.
"""
struct ClusterSample <: AbstractSurveyDesign
    data::DataFrame
end

# `show` method for printing information about a `ClusterSample` after construction
function Base.show(io::IO, design::ClusterSample)
    printstyled("Simple Random Sample:\n")
    printstyled("data: "; bold = true)
    print(size(design.data)[1], "x", size(design.data)[2], " DataFrame")
    printstyled("\nprobs: "; bold = true)
    print_short(design.data.probs)
    # TODO: change fpc
    printstyled("\nfpc: "; bold = true)
    print("\n    popsize: ")
    print_short(design.data.popsize)
    print("\n    sampsize: ")
    print_short(design.data.sampsize)
end
