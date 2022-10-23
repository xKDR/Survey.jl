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
