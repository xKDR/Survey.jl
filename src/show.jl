"""
Helper function that transforms a given `Number` or `Vector` into a short-form string.
"""
function makeshort(x)
    if isa(x[1], Float64)
        x = round.(x, sigdigits=3)
    end
    # print short vectors or single values as they are, compress otherwise
    x = length(x) < 3 ? join(x, ", ") : join(x[1:3], ", ") * ", ..., " * string(last(x))
end

"""
Print information in the form:
    **name:** content[\n]
"""
function printinfo(io::IO, name::String, content::String; newline::Bool=true)
    printstyled(io, name, ": "; bold=true)
    newline ? println(io, content) : print(io, content)
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

function Base.show(io::IO, ::MIME"text/plain", design::StratifiedSample)
    type = typeof(design)
    printstyled(io, "$type:\n"; bold=true)
    printstyled(io, "data: "; bold=true)
    println(io, size(design.data, 1), "x", size(design.data, 2), " DataFrame")
    printinfo(io, "strata", string(design.strata); newline=true)
    printinfo(io, "weights", makeshort(design.data.weights))
    printinfo(io, "probs", makeshort(design.data.probs))
    printinfo(io, "fpc", makeshort(design.data.fpc))
    printinfo(io, "popsize", makeshort(design.data.popsize))
    printinfo(io, "sampsize", makeshort(design.data.sampsize))
    printinfo(io, "sampfraction", makeshort(design.data.sampfraction))
    printinfo(io, "ignorefpc", string(design.ignorefpc); newline=false)
end

"Print information about a survey design."
function Base.show(io::IO, ::MIME"text/plain", design::SurveyDesign)
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
    # printinfo(io, "weights", string(design.weights); newline=true)
    # printinfo(io, "design.data[!,design.weights]", makeshort(design.data[!,design.weights]))
    # printinfo(io, "design.data[!,:strata]", makeshort(design.data[!,:strata]))
    printinfo(io, "design.data[!,:probs]", makeshort(design.data.probs))
    printinfo(io, "design.data[!,:allprobs]", makeshort(design.data.allprobs))
end