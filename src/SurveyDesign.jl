# Helper function for nice printing
function print_short(x)
    # write floats in short form
    if isa(x[1], Float64)
        x = round.(x, sigdigits=3)
    end
    # print short vectors or single values as they are, compress otherwise
    if length(x) < 3
        print(x)
    else
        print(x[1], ", ", x[2], ", ", x[3], " ... ", last(x))
    end
end

"""
Supertype for every survey design type: `SimpleRandomSample`, `ClusterSample`
and `StratifiedSample`.

The data to a survey constructor is modified. To avoid this pass a copy of the data
instead of the original.
"""
abstract type AbstractSurveyDesign end
"""
    SimpleRandomSample <: AbstractSurveyDesign

Survey design sampled by simple random sampling.
"""
struct SimpleRandomSample <: AbstractSurveyDesign
    data::AbstractDataFrame
    sampsize::Union{Nothing,Unsigned}
    popsize::Union{Nothing,Unsigned}
    sampfraction::Real
    fpc::Real
    ignorefpc::Bool
    function SimpleRandomSample(data::AbstractDataFrame;
        popsize=nothing,
        sampsize=nrow(data),
        weights=nothing, # Check the defaults
        probs=nothing,
        ignorefpc=false
    )
        # Functionality: weights arg can be passed as Symbol instead of vector
        if isa(weights, Symbol)
            weights = data[!, weights]
        end
        # Set population size if it is not given; `weights` and `sampsize` must be given
        if ignorefpc # && (isnothing(popsize) || isnothing(weights) || isnothing(probs))
            @warn "Assuming equal weights"
            weights = ones(nrow(data))
        end
        if isnothing(popsize)
            if typeof(weights) <: Vector{<:Real}
                if !all(y -> y == first(weights), weights) # SRS by definition is equi-weighted
                    error("Simple Random Sample must be equi-weighted. Different sampling weights detected in vectors")
                end
            elseif isa(weights, Symbol)
                weights = data[!, weights]
                if !all(y -> y == first(weights), weights) # SRS by definition is equi-weighted
                    error("Simple Random Sample must be equi-weighted. Different sampling weights detected in vectors")
                end
            elseif typeof(probs) <: Vector{<:Real}
                if !all(y -> y == first(probs), probs) # SRS by definition is equi-weighted
                    error("Simple Random Sample must be equi-weighted. Different sampling probabilities detected in vector")
                end
                weights = 1 ./ probs
            elseif isa(probs, Symbol)
                probs = data[!, probs]
                if !all(y -> y == first(probs), probs) # SRS by definition is equi-weighted
                    error("Simple Random Sample must be equi-weighted. Different sampling probabilities detected in vector")
                end
                weights = 1 ./ probs
            end
            # If all weights are equal then estimate
            equal_weight = first(weights)
            popsize = round(sampsize .* equal_weight) |> UInt
            if sampsize > popsize
                error("You have either given wrong or not enough keyword args. sampsize cannot be greate than popsize. Check given inputs. eg if weights given then popsize must be given (for now)")
            end
        elseif typeof(popsize) <: Vector{<:Real}
            if !all(y -> y == first(popsize), popsize) # SRS by definition is equi-weighted
                error("Simple Random Sample must be equi-weighted. Different sampling weights detected in vectors")
            end
            weights = popsize ./ sampsize # This line is ratio estimator, we may need to change it when doing compley surveys
            popsize = first(popsize) |> UInt
        else
            error("If popsize not given then either sampling weights or sampling probabilities must be given")
        end
        # set sampling fraction
        sampfraction = sampsize ./ popsize
        # set fpc
        fpc = ignorefpc ? 1 : 1 .- (sampsize ./ popsize)
        # Add columns for weights and probs in data -- Check if really needed to add them as columns
        if !isnothing(probs)
            # add probability weights column to `data`
            data[!, :probs] = probs
            # add frequency weights column to `data`
            data[!, :weights] = 1 ./ data[!, :probs]
        else # else weights were specified
            # add frequency weights column to `data`
            data[!, :weights] = weights
            # add probability weights column to `data`
            data[!, :probs] = 1 ./ data[!, :weights]
        end
        new(data, sampsize, popsize, sampfraction, fpc, ignorefpc)
    end
    function SimpleRandomSample(data::AbstractDataFrame)
        ignorefpc = true
        return SimpleRandomSample(data; popsize=nothing,sampsize=nrow(data), weights=nothing, probs=nothing, ignorefpc=ignorefpc)
    end
end

# `show` method for printing information about a `SimpleRandomSample` after construction
function Base.show(io::IO, ::MIME"text/plain", design::SimpleRandomSample)
    printstyled("Simple Random Sample:\n"; bold=true)
    printstyled("data: "; bold=true)
    print(size(design.data, 1), "x", size(design.data, 2), " DataFrame")
    printstyled("\ndata.weights: "; bold=true)
    print_short(design.data.weights)
    printstyled("\ndata.probs: "; bold=true)
    print_short(design.data.probs)
    printstyled("\nfpc: "; bold=true)
    print_short(design.fpc)
    printstyled("\npopsize: "; bold=true)
    print_short(design.popsize)
    printstyled("\nsampsize: "; bold=true)
    print_short(design.sampsize)
    printstyled("\nsampfraction: "; bold=true)
    print_short(design.sampfraction)
    printstyled("\nignorefpc: "; bold=true)
    print(design.ignorefpc)
end

"""
    StratifiedSample <: AbstractSurveyDesign

Survey design sampled by stratification.
"""
struct StratifiedSample <: AbstractSurveyDesign
    data::AbstractDataFrame
    strata::Symbol
    sampsize::Vector{Union{Nothing,Float64}}
    popsize::Vector{Union{Nothing,Float64}}
    sampfraction::Vector{Real}
    fpc::Vector{Real}
    ignorefpc::Bool
    function StratifiedSample(data::AbstractDataFrame, strata::Symbol;
        popsize=nothing,
        sampsize= transform(groupby(data,strata), nrow => :counts ).counts ,
        weights=nothing, # Check the defaults
        probs=nothing,
        ignorefpc=false
    )
        # Functionality: weights arg can be passed as Symbol instead of vector
        if isa(weights, Symbol)
            weights = data[!, weights]
        end
        # Set population size if it is not given; `weights` and `sampsize` must be given
        if ignorefpc # && (isnothing(popsize) || isnothing(weights) || isnothing(probs))
            @warn "Assuming equal weights"
            weights = ones(nrow(data))
        end
        if isnothing(popsize)
            # if typeof(weights) <: Vector{<:Real}
            #     if !all(y -> y == first(weights), weights) # SRS by definition is equi-weighted
            #         error("Simple Random Sample must be equi-weighted. Different sampling weights detected in vectors")
            #     end
            if isa(weights, Symbol)
                weights = data[!, weights]
                # if !all(y -> y == first(weights), weights) # SRS by definition is equi-weighted
                #     error("Simple Random Sample must be equi-weighted. Different sampling weights detected in vectors")
                # end
            elseif typeof(probs) <: Vector{<:Real}
                # if !all(y -> y == first(probs), probs) # SRS by definition is equi-weighted
                #     error("Simple Random Sample must be equi-weighted. Different sampling probabilities detected in vector")
                # end
                weights = 1 ./ probs
            elseif isa(probs, Symbol)
                probs = data[!, probs]
                # if !all(y -> y == first(probs), probs) # SRS by definition is equi-weighted
                #     error("Simple Random Sample must be equi-weighted. Different sampling probabilities detected in vector")
                # end
                weights = 1 ./ probs
            end
            # If all weights are equal then estimate
            # equal_weight = first(weights)
            popsize = sampsize .* weights # |> Vector{Float64}

            if sampsize > popsize
                error("You have either given wrong or not enough keyword args. sampsize cannot be greate than popsize. Check given inputs. eg if weights given then popsize must be given (for now)")
            end
        elseif typeof(popsize) <: Vector{<:Real}
            # if !all(y -> y == first(popsize), popsize) # SRS by definition is equi-weighted
            #     error("Simple Random Sample must be equi-weighted. Different sampling weights detected in vectors")
            # end
            # @show(popsize,sampsize)
            weights = popsize ./ sampsize # This line is expansion estimator, we may need to change it when doing compley surveys
            # popsize = first(popsize) |> UInt
        else
            error("If popsize not given then either sampling weights or sampling probabilities must be given")
        end
        # set sampling fraction
        sampfraction = sampsize ./ popsize
        # set fpc
        fpc = ignorefpc ? 1 : 1 .- (sampsize ./ popsize)
        # Add columns for weights and probs in data -- Check if really needed to add them as columns
        if !isnothing(probs)
            # add probability weights column to `data`
            data[!, :probs] = probs
            # add frequency weights column to `data`
            data[!, :weights] = 1 ./ data[!, :probs]
        else # else weights were specified
            # add frequency weights column to `data`
            data[!, :weights] = weights
            # add probability weights column to `data`
            data[!, :probs] = 1 ./ data[!, :weights]
        end
        new(data, strata, sampsize, popsize, sampfraction, fpc, ignorefpc)
    end
    function StratifiedSample(data::AbstractDataFrame,strata::Symbol)
        ignorefpc = true
        return StratifiedSample(data,strata; popsize=nothing,sampsize= transform(groupby(data,strata), nrow => :counts ).counts, weights=nothing, probs=nothing, ignorefpc=ignorefpc)
    end
end

# `show` method for printing information about a `StratifiedSample` after construction
function Base.show(io::IO, design::StratifiedSample)
    printstyled("Stratified Sample:\n"; bold=true)
    printstyled("data: "; bold=true)
    print(size(design.data, 1), "x", size(design.data, 2), " DataFrame")
    printstyled("\nstrata: "; bold=true)
    print(design.strata)
    printstyled("\ndata.weights: "; bold=true)
    print_short(design.data.weights)
    printstyled("\ndata.probs: "; bold=true)
    print_short(design.data.probs)
    printstyled("\nfpc: "; bold=true)
    print_short(design.fpc)
    printstyled("\npopsize: "; bold=true)
    print_short(design.popsize)
    printstyled("\nsampsize: "; bold=true)
    print_short(design.sampsize)
end

"""
    GeneralSample <: AbstractSurveyDesign

Survey design sampled by clustering.
"""
struct GeneralSample <: AbstractSurveyDesign
    data::AbstractDataFrame
    strata::Symbol
    sampsize::Vector{Union{Nothing,Float64}}
    popsize::Vector{Union{Nothing,Float64}}
    sampfraction::Vector{Real}
    fpc::Vector{Real}
    ignorefpc::Bool
    function StratifiedSample(data::AbstractDataFrame, strata::Symbol;
        popsize=nothing,
        sampsize= transform(groupby(data,strata), nrow => :counts ).counts ,
        weights=nothing, # Check the defaults
        probs=nothing,
        ignorefpc=false
    )
        # Functionality: weights arg can be passed as Symbol instead of vector
        if isa(weights, Symbol)
            weights = data[!, weights]
        end
        # Set population size if it is not given; `weights` and `sampsize` must be given
        if ignorefpc # && (isnothing(popsize) || isnothing(weights) || isnothing(probs))
            @warn "Assuming equal weights"
            weights = ones(nrow(data))
        end
        if isnothing(popsize)
            # if typeof(weights) <: Vector{<:Real}
            #     if !all(y -> y == first(weights), weights) # SRS by definition is equi-weighted
            #         error("Simple Random Sample must be equi-weighted. Different sampling weights detected in vectors")
            #     end
            if isa(weights, Symbol)
                weights = data[!, weights]
                # if !all(y -> y == first(weights), weights) # SRS by definition is equi-weighted
                #     error("Simple Random Sample must be equi-weighted. Different sampling weights detected in vectors")
                # end
            elseif typeof(probs) <: Vector{<:Real}
                # if !all(y -> y == first(probs), probs) # SRS by definition is equi-weighted
                #     error("Simple Random Sample must be equi-weighted. Different sampling probabilities detected in vector")
                # end
                weights = 1 ./ probs
            elseif isa(probs, Symbol)
                probs = data[!, probs]
                # if !all(y -> y == first(probs), probs) # SRS by definition is equi-weighted
                #     error("Simple Random Sample must be equi-weighted. Different sampling probabilities detected in vector")
                # end
                weights = 1 ./ probs
            end
            # If all weights are equal then estimate
            # equal_weight = first(weights)
            popsize = sampsize .* weights # |> Vector{Float64}

            if sampsize > popsize
                error("You have either given wrong or not enough keyword args. sampsize cannot be greate than popsize. Check given inputs. eg if weights given then popsize must be given (for now)")
            end
        elseif typeof(popsize) <: Vector{<:Real}
            # if !all(y -> y == first(popsize), popsize) # SRS by definition is equi-weighted
            #     error("Simple Random Sample must be equi-weighted. Different sampling weights detected in vectors")
            # end
            # @show(popsize,sampsize)
            weights = popsize ./ sampsize # This line is expansion estimator, we may need to change it when doing compley surveys
            # popsize = first(popsize) |> UInt
        else
            error("If popsize not given then either sampling weights or sampling probabilities must be given")
        end
        # set sampling fraction
        sampfraction = sampsize ./ popsize
        # set fpc
        fpc = ignorefpc ? 1 : 1 .- (sampsize ./ popsize)
        # Add columns for weights and probs in data -- Check if really needed to add them as columns
        if !isnothing(probs)
            # add probability weights column to `data`
            data[!, :probs] = probs
            # add frequency weights column to `data`
            data[!, :weights] = 1 ./ data[!, :probs]
        else # else weights were specified
            # add frequency weights column to `data`
            data[!, :weights] = weights
            # add probability weights column to `data`
            data[!, :probs] = 1 ./ data[!, :weights]
        end
        new(data, strata, sampsize, popsize, sampfraction, fpc, ignorefpc)
    end
    function StratifiedSample(data::AbstractDataFrame,strata::Symbol)
        ignorefpc = true
        return StratifiedSample(data,strata; popsize=nothing,sampsize= transform(groupby(data,strata), nrow => :counts ).counts, weights=nothing, probs=nothing, ignorefpc=ignorefpc)
    end
end

# `show` method for printing information about a `ClusterSample` after construction
function Base.show(io::IO, design::GeneralSample)
    printstyled("Cluster Sample:\n"; bold=true)
    printstyled("data: "; bold=true)
    print(size(design.data, 1), "x", size(design.data, 2), " DataFrame")
    printstyled("\nweights: "; bold=true)
    print_short(design.data.weights)
    printstyled("\nprobs: "; bold=true)
    print_short(design.data.probs)
    printstyled("\nfpc: "; bold=true)
    print_short(design.fpc)
    printstyled("\n    popsize: "; bold=true)
    print(design.popsize)
    printstyled("\n    sampsize: "; bold=true)
    print(design.sampsize)
end
