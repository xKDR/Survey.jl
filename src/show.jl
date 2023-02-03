"""
Helper function that transforms a given `Number` or `Vector` into a short-form string.
"""
function makeshort(x)
    if isa(x[1], Float64)
        x = round.(x, digits=4) # Rounded to 4 digits after the decimal place
    end
    if typeof(x) <: Number # TODO: use multiple dispatch. 
        return string(x)
    end
    # Compress long vectors
    if length(x) > 4
        return "[" * (length(x) < 3 ? join(x, ", ") : join(x[1:3], ", ") * "  …  " * string(last(x))) * "]"
    else
        return "[" * join(x, ", ") * "]"
    end
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
Base.show(io::IO, ::MIME"text/plain", design::SurveyDesign) = 
    surveyshow(io, design)

"Print information about a replicate weights design."
function Base.show(io::IO, ::MIME"text/plain", design::ReplicateDesign)
    # new_io = IOContext(io, :compact=>true, :limit=>true, :displaysize=>(50, 50))
    surveyshow(io, design)
    printinfo(io, "\nreplicates", design.replicates; newline=false)
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
    printinfo(io, "popsize", makeshort(design.data[!, design.popsize]))
    printinfo(io, "sampsize", makeshort(design.data[!, design.sampsize]))
    # weights and probs info
    printinfo(io, "weights", makeshort(design.data[!, design.weights]))
    printinfo(io, "allprobs", makeshort(design.data[!, design.allprobs]); newline=false)
end
