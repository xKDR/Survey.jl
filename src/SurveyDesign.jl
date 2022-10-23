"""
    AbstractSurveyDesign

Supertype for every survey design type: [`SimpleRandomSample`](@ref), [`StratifiedSample`](@ref)
and [`ClusterSample`](@ref).

!!! note

    The data passed to a survey constructor is modified. To avoid this pass a copy of the data
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
        weights=nothing,
        probs=nothing,
        ignorefpc=false
    )
        if isa(weights, Symbol)
            weights = data[!, weights]
        end
        if isa(probs, Symbol)
            probs = data[!, probs]
        end

        if ignorefpc
            @warn "assuming all weights are equal to 1.0"
            weights = ones(nrow(data))
        end

        # set population size if it is not given; `weights` and `sampsize` must be given
        if isnothing(popsize)
            # check that all weights are equal (SRS is by definition equi-weighted)
            if typeof(weights) <: Vector{<:Real}
                if !all(w -> w == first(weights), weights)
                    error("all frequency weights must be equal for Simple Random Sample")
                end
            elseif typeof(probs) <: Vector{<:Real}
                if !all(p -> p == first(probs), probs)
                    error("all probability weights must be equal for Simple Random Sample")
                end
                weights = 1 ./ probs
            end
            # estimate population size
            popsize = round(sampsize .* first(weights)) |> UInt
            if sampsize > popsize
                error("sample size cannot be greater than population size")
            end
        elseif typeof(popsize) <: Vector{<:Real}
            if !all(y -> y == first(popsize), popsize) # SRS by definition is equi-weighted
                error("Simple Random Sample must be equi-weighted. Different sampling weights detected in vectors")
            end
            weights = popsize ./ sampsize # ratio estimator for SRS
            popsize = first(popsize) |> UInt
        else
            error("either population size or frequency/probability weights must be specified")
        end
        # set sampling fraction
        sampfraction = sampsize ./ popsize
        # set fpc
        fpc = ignorefpc ? 1 : 1 .- (sampsize ./ popsize)
        # add columns for frequency and probability weights to `data`
        data[!, :weights] = weights
        if isnothing(probs)
            probs = 1 ./ data[!, :weights] 
        end
        data[!, :probs] = probs

        new(data, sampsize, popsize, sampfraction, fpc, ignorefpc)
    end
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
        weights=nothing,
        probs=nothing,
        ignorefpc=false
    )
        if isa(weights, Symbol)
            weights = data[!, weights]
        end
        if isa(probs, Symbol)
            probs = data[!, probs]
        end

        if ignorefpc
            # TODO: change what happens if `ignorepfc == true` or if the user only
            # specifies `data`
            @warn "assuming equal weights"
            weights = ones(nrow(data))
        end

        # set population size if it is not given; `weights` and `sampsize` must be given
        if isnothing(popsize)
            # TODO: add probability weights if `weights` is not `nothing`
            if typeof(probs) <: Vector{<:Real}
                weights = 1 ./ probs
            end
            # estimate population size
            popsize = sampsize .* weights

            if sampsize > popsize
                error("sample size cannot be greater than population size")
            end
        elseif typeof(popsize) <: Vector{<:Real}
            # TODO: change `elseif` condition
            weights = popsize ./ sampsize # expansion estimator
            # TODO: add probability weights
        else
            error("either population size or frequency/probability weights must be specified")
        end
        # set sampling fraction
        sampfraction = sampsize ./ popsize
        # set fpc
        fpc = ignorefpc ? 1 : 1 .- (sampsize ./ popsize)
        # add columns for frequency and probability weights to `data`
        if !isnothing(probs)
            data[!, :probs] = probs
            data[!, :weights] = 1 ./ data[!, :probs]
        else
            data[!, :weights] = weights
            data[!, :probs] = 1 ./ data[!, :weights]
        end
        new(data, strata, sampsize, popsize, sampfraction, fpc, ignorefpc)
    end
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
    # TODO: change entire struct body
    function GeneralSample(data::AbstractDataFrame, strata::Symbol;
        popsize=nothing,
        sampsize= transform(groupby(data,strata), nrow => :counts ).counts ,
        weights=nothing,
        probs=nothing,
        ignorefpc=false
    )
        if isa(weights, Symbol)
            weights = data[!, weights]
        end
        if isa(probs, Symbol)
            probs = data[!, probs]
        end

        if ignorefpc # && (isnothing(popsize) || isnothing(weights) || isnothing(probs))
            @warn "Assuming equal weights"
            weights = ones(nrow(data))
        end

        # set population size if it is not given; `weights` and `sampsize` must be given
        if isnothing(popsize)
            # TODO: add probability weights if `weights` is not `nothing`
            if typeof(probs) <: Vector{<:Real}
                weights = 1 ./ probs
            end
            # estimate population size
            popsize = sampsize .* weights

            if sampsize > popsize
                error("sample size cannot be greater than population size")
            end
        elseif typeof(popsize) <: Vector{<:Real}
            # TODO: change `elseif` condition
            weights = popsize ./ sampsize # expansion estimator
            # TODO: add probability weights
        else
            error("either population size or frequency/probability weights must be specified")
        end
        # set sampling fraction
        sampfraction = sampsize ./ popsize
        # set fpc
        fpc = ignorefpc ? 1 : 1 .- (sampsize ./ popsize)
        # add columns for frequency and probability weights to `data`
        if !isnothing(probs)
            data[!, :probs] = probs
            data[!, :weights] = 1 ./ data[!, :probs]
        else
            data[!, :weights] = weights
            data[!, :probs] = 1 ./ data[!, :weights]
        end
        new(data, strata, sampsize, popsize, sampfraction, fpc, ignorefpc)
    end
end
