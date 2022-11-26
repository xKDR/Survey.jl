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
    # Required arguments:
    data - This is the survey dataset loaded as a DataFrame in memory. 
           Note: Keeping with Julia conventions, original data object
           is modified, not copied. Be careful
    # Optional arguments:
    sampsize -  Sample size of the survey, given as Symbol name of 
                column in `data`, an `Unsigned` integer, or a Vector
    popsize  -  The (expected) population size of survey, given as Symbol 
                name of column in `data`, an `Unsigned` integer, or a Vector
    weights  -  Sampling weights, passed as Symbol or Vector
    probs    -  Sampling probabilities, passed as Symbol or Vector
    ignorefpc-  Ignore finite population correction and assume all weights equal to 1.0
    
    Precedence order of using `popsize`, `weights` and `probs` is `popsize` > `weights` > `probs` 
    Eg. if `popsize` given then assumed ground truth over `weights` or `probs`

    If `popsize` not given, `weights` or `probs` must be given, so that in combination 
    with `sampsize`, `popsize` can be calculated.
"""
struct SimpleRandomSample <: AbstractSurveyDesign
    data::AbstractDataFrame
    sampsize::Union{Unsigned,Nothing}
    popsize::Union{Unsigned,Nothing}
    sampfraction::Float64
    fpc::Float64
    ignorefpc::Bool
    function SimpleRandomSample(data::AbstractDataFrame;
        popsize=nothing,
        sampsize=nrow(data) |> UInt,
        weights=nothing,
        probs=nothing,
        ignorefpc=false
    )
        # Only valid argument types given to constructor
        argtypes_weights = Union{Nothing,Symbol,Vector{<:Real}}
        argtypes_probs = Union{Nothing,Symbol,Vector{<:Real}}
        argtypes_popsize = Union{Nothing,Symbol,<:Unsigned,Vector{<:Real}}
        argtypes_sampsize = Union{Nothing,Symbol,<:Unsigned,Vector{<:Real}}
        # If any invalid type raise error
        if !(isa(weights, argtypes_weights))
            error("invalid type of argument given for `weights` argument")
        elseif !(isa(probs, argtypes_probs))
            error("Invalid type of argument given for `probs` argument")
        elseif !(isa(popsize, argtypes_popsize))
            error("Invalid type of argument given for `popsize` argument")
        elseif !(isa(sampsize, argtypes_sampsize))
            error("Invalid type of argument given for `sampsize` argument")
        end
        # If any of weights or probs given as Symbol,
        # find the corresponding column in `data`
        if isa(weights, Symbol)
            weights = data[!, weights]
        end
        if isa(probs, Symbol)
            probs = data[!, probs]
        end
        # If weights/probs vector not numeric/real, ie. string column passed for weights, then raise error
        if !isa(weights, Union{Nothing,Vector{<:Real}})
            error("Weights should be Vector{<:Real}. You passed $(typeof(weights))")
        elseif !isa(probs, Union{Nothing,Vector{<:Real}})
            error("Sampling probabilities should be Vector{<:Real}. You passed $(typeof(probs))")
        end
        # If popsize given as Symbol or Vector, check all records equal 
        if isa(popsize, Symbol)
            if !all(w -> w == first(data[!, popsize]), data[!, popsize])
                error("popsize must be same for all observations in Simple Random Sample")
            end
            popsize = first(data[!, popsize]) |> UInt
        elseif isa(popsize, Vector{<:Real})
            if !all(w -> w == first(popsize), popsize)
                error("popsize must be same for all observations in Simple Random Sample")
            end
            popsize = first(popsize) |> UInt
        end
        # If sampsize given as Symbol or Vector, check all records equal 
        if isa(sampsize, Symbol)
            if !all(w -> w == first(data[!, sampsize]), data[!, sampsize])
                error("sampsize must be same for all observations in Simple Random Sample")
            end
            sampsize = first(data[!, sampsize]) |> UInt
        elseif isa(sampsize, Vector{<:Real})
            if !all(w -> w == first(sampsize), sampsize)
                error("sampsize must be same for all observations in Simple Random Sample")
            end
            sampsize = first(sampsize) |> UInt
        end
        # If both `weights` and `probs` given, then `weights` is assumed to be ground truth for probs.
        if !isnothing(weights) && !isnothing(probs)
            probs = 1 ./ weights
            data[!, :probs] = probs
        end
        # popsize must be nothing or <:Integer by now
        if isnothing(popsize)
            # If popsize not given, fallback to weights, probs and sampsize to estimate `popsize`
            @warn "Using weights/probs and sampsize to estimate `popsize`"
            # Check that all weights (or probs if weights not given) are equal, as SRS is by definition equi-weighted
            if typeof(weights) <: Vector{<:Real}
                if !all(w -> w == first(weights), weights)
                    error("all frequency weights must be equal for Simple Random Sample")
                end
            elseif typeof(probs) <: Vector{<:Real}
                if !all(p -> p == first(probs), probs)
                    error("all probability weights must be equal for Simple Random Sample")
                end
                weights = 1 ./ probs
            else
                error("either weights or probs must be given if `popsize` not given")
            end
            # Estimate population size
            popsize = round(sampsize * first(weights)) |> UInt
            if sampsize > popsize
                error("population size was estimated to be greater than given sampsize. Please check input arguments.")
            end
        elseif typeof(popsize) <: Unsigned
            weights = fill(popsize / sampsize, nrow(data)) # If popsize is given, weights vector is made concordant with popsize and sampsize, regardless of given weights argument
        else
            error("Something went wrong. Please check validity of inputs.")
        end
        # If ignorefpc then set weights to 1 ??
        # TODO: This works under some cases, but should find better way to process ignoring fpc
        if ignorefpc
            @warn "assuming all weights are equal to 1.0"
            weights = ones(nrow(data))
            probs = 1 ./ weights
        end
        # sum of weights must equal to `popsize` for SRS
        if !isnothing(weights) && !(isapprox(sum(weights), popsize; atol=1e-4))
            if ignorefpc && !(isapprox(sum(weights), sampsize; atol=1e-4)) # Change if ignorefpc functionality changes
                error("Sum of sampling weights should be equal to `sampsize` for Simple Random Sample with ignorefpc")
            elseif !ignorefpc
                @show sum(weights)
                error("Sum of sampling weights must be equal to `popsize` for Simple Random Sample")
            end
        end
        # sum of probs must equal popsize for SRS
        if !isnothing(probs) && !(isapprox(sum(1 ./ probs), popsize; atol=1e-4))
            if ignorefpc && !(isapprox(sum(1 ./ probs), sampsize; atol=1e-4)) # Change if ignorefpc functionality changes
                error("Sum of inverse sampling probabilities should be equal to `sampsize` for Simple Random Sample with ignorefpc")
            elseif !ignorefpc
                @show sum(1 ./ probs)
                error("Sum of inverse of sampling probabilities must be equal to `popsize` for Simple Random Sample")
            end
        end
        ## Set remaining parts of data structure
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
        # Initialise the structure
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
        if isa(popsize, Symbol)
            popsize = data[!, popsize]
        end
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
        fpc = ignorefpc ? fill(1, size(data, 1)) : 1 .- (sampsize ./ popsize)
        # add columns for frequency and probability weights to `data`
        if !isnothing(probs)
            data[!, :probs] = probs
            data[!, :weights] = 1 ./ data[!, :probs]
        else
            data[!, :weights] = weights
            data[!, :probs] = 1 ./ data[!, :weights]
        end
        data[!, :sampsize] = sampsize
        data[!, :popsize] = popsize
        data[!, :fpc] = fpc
        data[!, :sampfraction] = sampfraction
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
        elseif isa(clusters, Symbol)
            # One Cluster sampling - PSU chosen with SRS,
            print("One stage cluster design with PSU SRS")
        elseif typeof(clusters) <: Vector{Symbol}
            # TODO "Multistage cluster designs"
            print("TODO: Multistage cluster design with PSU SRS")
        end
    end
end