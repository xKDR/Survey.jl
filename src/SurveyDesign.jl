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
                weights = 1 / probs
            end
            # estimate population size
            popsize = round(sampsize * first(weights)) |> UInt
            @show popsize, sampsize
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
        sampfraction = sampsize / popsize
        # set fpc
        fpc = ignorefpc ? 1 : 1 - (sampsize / popsize)
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
    sampsize::Union{Nothing,Vector{Real}}
    popsize::Union{Nothing,Vector{Real}}
    sampfraction::Vector{Real}
    fpc::Vector{Real}
    ignorefpc::Bool
    function StratifiedSample(data::AbstractDataFrame, strata::Symbol;
        popsize=nothing,
        sampsize=transform(groupby(data, strata), nrow => :counts).counts,
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
    ClusterSample <: AbstractSurveyDesign

    One stage clusters, Primary Sampling Units (PSU) chosen with SRS. No stratification.
    Assuming every individual is in one and only one cluster, and the subsampling probabilities
    for any given cluster do not depend on which other clusters were sampled. (Lumley pg41, para2)
"""
struct ClusterSample <: AbstractSurveyDesign
    data::AbstractDataFrame
    clusters::Union{Symbol,Nothing}
    sampsize::Union{Nothing,Vector{Real}}
    popsize::Union{Nothing,Vector{Real}}
    sampfraction::Vector{Real}
    fpc::Vector{Real}
    ignorefpc::Bool
    function ClusterSample(data::AbstractDataFrame, strata::Symbol;
        popsize=nothing,
        sampsize=transform(groupby(data, strata), nrow => :counts).counts,
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
    SurveyDesign <: AbstractSurveyDesign
    
    Survey design with arbitrary design weights

    clusters: can be passed as `Symbol`, Vector{Symbol}, Vector{Real} or Nothing
    strata: can be passed as `Symbol`, Vector{Symbol}, Vector{Real} or Nothing
    sampsize: can be passed as `Symbol`, Vector{Symbol}, Vector{Real} or Nothing
    popsize: can be passed as `Symbol`, Vector{Symbol}, Vector{Real} or Nothing
"""
struct SurveyDesign <: AbstractSurveyDesign
    data::AbstractDataFrame
    clusters::Union{Symbol,Vector{Symbol},Nothing}
    strata::Union{Symbol,Vector{Symbol},Nothing}
    sampsize::Union{Real,Vector{Real},Nothing}
    popsize::Union{Real,Vector{Real},Nothing}
    sampfraction::Union{Real,Vector{Real}}
    fpc::Union{Real,Vector{Real}}
    ignorefpc::Bool
    # TODO: struct body still work in progress
    function SurveyDesign(data::AbstractDataFrame;
        clusters=nothing,
        strata=nothing,
        popsize=nothing,
        sampsize=nothing,
        weights=nothing,
        probs=nothing,
        ignorefpc=false
    )
        if isnothing(sampsize)
            if isnothing(strata)
                sampsize = nrow(data)
            else
                sampsize = transform(groupby(data, strata), nrow => :counts).counts
            end

        end

        if isa(weights, Symbol)
            weights = data[!, weights]
        end
        if isa(probs, Symbol)
            probs = data[!, probs]
        end
        if isa(popsize, Symbol)
            popsize = data[!, popsize]
        end

        # TODO: Check below, may not be correct for all designs
        if ignorefpc # && (isnothing(popsize) || isnothing(weights) || isnothing(probs))
            @warn "Assuming equal weights"
            weights = ones(nrow(data))
        end    
        
        # TODO: Do the other case where clusters are given
        if isnothing(clusters)
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
            # TODO: for now support SRS within SurveyDesign. Later, just call SimpleRandomSample??
            if typeof(sampsize) <: Real && typeof(popsize) <: Vector{<:Real} # Eg when SRS
                if !all(y -> y == first(popsize), popsize) # SRS by definition is equi-weighted
                    error("Simple Random Sample must be equi-weighted. Different sampling weights detected in vectors")
                end
                popsize = first(popsize) |> Real
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
            # @show clusters, strata, sampsize,popsize, sampfraction, fpc, ignorefpc
            new(data, clusters, strata, sampsize, popsize, sampfraction, fpc, ignorefpc)
        elseif isa(clusters,Symbol)
            # One Cluster sampling - PSU chosen with SRS,
            print("One stage cluster design with PSU SRS")
        elseif typeof(clusters) <: Vector{Symbol}
            # TODO "Multistage cluster designs"
            print("TODO: Multistage cluster design with PSU SRS")
        end
    end
end