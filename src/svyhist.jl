using Survey
using CairoMakie
using DataFrames

sturges(n::Integer) = ceil(Int, log2(n) + 1)

sturges(vec::Vector) = ceil(Int, log2(size(vec)[1]) + 1)

sturges(df::DataFrame, var::Symbol) = ceil(Int, log2(size(df[!, var])[1]) + 1)

sturges(design::svydesign, var::Symbol) = sturges(design.variables, var)


"""
Histogram plot of a survey design variable.
"""

function svyhist(design::svydesign, var::Symbol; bins = sturges(design, var),
				normalization = :density,
				weights::Vector = ones(size(design.variables)[1]))
	hist(design.variables[!, var], bins = bins, normalization = normalization, weights = weights)
end

function svyhist(design::svydesign, var::Symbol; bins = sturges(design, var),
				normalization = :density,
				weights::Symbol)
	weights = design.variables[!, weights]
	hist(design.variables[!, var], bins = bins, normalization = normalization, weights = weights)
end
