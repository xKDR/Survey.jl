surveyio(io) = IOContext(io, :compact=>true, :limit=>true, :displaysize=>(50, 50))

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
Base.show(io::IO, ::MIME"text/plain", design::AbstractSurveyDesign) =
    surveyshow(surveyio(io), design)

Base.show(io::IO, ::MIME"text/plain", design::SurveyDesign) = 
    surveyshow(surveyio(io), design)

function Base.show(io::IO, ::MIME"text/plain", design::ReplicateDesign)
    # new_io = IOContext(io, :compact=>true, :limit=>true, :displaysize=>(50, 50))
    surveyshow(surveyio(io), design)
    printinfo(surveyio(io), "\nreplicates", design.replicates; newline=false)
end

function surveyshow(io::IO, design::AbstractSurveyDesign)
    # structure name
    type = typeof(design)
    printstyled(io, "$type:\n"; bold=true)
    # data info
    printinfo(io, "data", summary(design.data))
    # strata info
    strata_content = design.strata == :false_strata ?
                     "none" :
                     (string(design.strata), "\n    ", makeshort(design.data[!, design.strata]))
    printinfo(io, "strata", strata_content...)
    # cluster(s) info
    cluster_content = design.cluster == :false_cluster ?
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
