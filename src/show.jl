"""
Helper function that transforms a given `Number` or `Vector` into a short-form string.
"""
function makeshort(x)
    if isa(x[1], Float64)
        x = round.(x, sigdigits=3)
    end
    # print short vectors or single values as they are, compress otherwise
    if length(x) > 1
        return "[" * (length(x) < 3 ? join(x, ", ") : join(x[1:3], ", ") * "  …  " * string(last(x))) * "]"
    end

    return x
end

"""
Print information in the form:
    **name:** content[\n]
"""
function printinfo(io::IO, name::String, content, args...; newline::Bool=true)
    printstyled(io, name, ": "; bold=true)
    newline ? println(io, content, args...) : print(io, content, args...)
end

"Print information about a survey design."
function Base.show(io::IO, ::MIME"text/plain", design::AbstractSurveyDesign)
    type = typeof(design)
    printstyled(io, "$type:\n"; bold=true)
    printstyled(io, "data: "; bold=true)
    println(io, size(design.data, 1), "x", size(design.data, 2), " DataFrame")
    printinfo(io, "weights", makeshort(design.data.weights))
    printinfo(io, "probs", makeshort(design.data.probs))
    printinfo(io, "fpc", makeshort(design.data.fpc))
    printinfo(io, "popsize", makeshort(design.popsize))
    printinfo(io, "sampsize", makeshort(design.sampsize))
    printinfo(io, "sampfraction", makeshort(design.sampfraction))
    printinfo(io, "ignorefpc", string(design.ignorefpc); newline=false)
end

"Print information about a survey design."
Base.show(io::IO, ::MIME"text/plain", design::SurveyDesign) = 
    surveyshow(IOContext(io, :compact=>true, :limit=>true, :displaysize=>(50, 50)), design)

function surveyshow(io::IO, design::SurveyDesign)
    # structure name
    type = typeof(design)
    printstyled(io, "$type:\n"; bold=true)
    # data info
    printinfo(io, "data", summary(design.data))
    # strata info
    strata_content =
        design.strata == :false_strata ?
            "none" :
            (string(design.strata), "\n    ", makeshort(design.data[!, design.strata]))
    printinfo(io, "strata", strata_content...)
    # cluster(s) info
    cluster_content =
        design.cluster == :false_cluster ?
            "none" :
            (string(design.cluster), "\n    ", makeshort(design.data[!, design.cluster]))
    printinfo(io, "cluster", cluster_content...)
    # popsize and sampsize info
    printinfo(io, "popsize", "\n    ", makeshort(design.data[!, design.popsize]))
    printinfo(io, "sampsize", "\n    ", makeshort(design.data[!, design.sampsize]))
    # weights and probs info
    printinfo(io, "weights", "\n    ", makeshort(design.data[!, :weights]))
    printinfo(io, "probs", "\n    ", makeshort(design.data[!, :probs]); newline=false)
end

"Print information about a replicate design."
function Base.show(io::IO, ::MIME"text/plain", design::ReplicateDesign)
    type = typeof(design)
    printstyled(io, "$type:\n"; bold=true)
    printstyled(io, "data: "; bold=true)
    println(io, size(design.data, 1), "x", size(design.data, 2), " DataFrame")
    printinfo(io, "cluster", string(design.cluster); newline=true)
    printinfo(io, "design.data[!,design.cluster]", makeshort(design.data[!,design.cluster]))
    printinfo(io, "popsize", string(design.popsize); newline=true)
    printinfo(io, "design.data[!,design.popsize]", makeshort(design.data[!,design.popsize]))
    printinfo(io, "sampsize", string(design.sampsize); newline=true)
    printinfo(io, "design.data[!,design.sampsize]", makeshort(design.data[!,design.sampsize]))
    printinfo(io, "design.data[!,:probs]", makeshort(design.data.probs))
    printinfo(io, "design.data[!,:allprobs]", makeshort(design.data.allprobs))
    printstyled(io, "replicates: "; bold=true)
    println(io, design.replicates)
end