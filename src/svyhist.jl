sturges(n::Integer) = ceil(Int, log2(n)) + 1

sturges(vec::AbstractVector) = ceil(Int, log2(length(vec))) + 1

sturges(df::DataFrame, var::Symbol) = ceil(Int, log2(size(df[!, var], 1))) + 1

sturges(design::svydesign, var::Symbol) = sturges(design.variables, var)


"""
Histogram plot of a survey design variable.
"""

function svyhist(design::svydesign, var::Symbol; bins = sturges(design, var),
				normalization = :density,
				weights::AbstractVector = ones(size(design.variables, 1)), kwargs...)
	hist(design.variables[!, var]; bins = bins, normalization = normalization, weights = weights, kwargs...)
end

function svyhist(design::svydesign, var::Symbol; bins = sturges(design, var),
				normalization = :density,
				weights::Symbol, kwargs...)
	weights = design.variables[!, weights]
	hist(design.variables[!, var]; bins = bins, normalization = normalization, weights = weights, kwargs...)
end
