using Survey
using Test

@testset "svyhist.jl" begin
	data(api)
	dstrat = svydesign(data = apistrat, id = :1, strata = :stype, weights = :pw, fpc = :fpc)

	sturges(n::Integer) = ceil(Int, log2(n)) + 1
	sturges(vec::AbstractVector) = ceil(Int, log2(length(vec))) + 1
	sturges(df::DataFrame, var::Symbol) = ceil(Int, log2(size(df[!, var], 1))) + 1
	sturges(design::svydesign, var::Symbol) = sturges(design.variables, var)

	@test sturges(10) == 5
	@test sturges([1, 2, 5, 10, 15, 17, 20]) == 4

	freedman_diaconis(v::AbstractVector) = round(Int, length(v)^(1 / 3) * (maximum(v) - minimum(v)) / (2 * iqr(v)))
	freedman_diaconis(df::DataFrame, var::Symbol) = freedman_diaconis(df[!, var])
	freedman_diaconis(design::svydesign, var::Symbol) = freedman_diaconis(design.variables[!, var])

	h = svyhist(dstrat, :enroll)
	@test getindex(h.plot.bins) == 15
	@test getindex(h.plot.weights) == ones(length(dstrat.variables.pw))

	h = svyhist(dstrat, :enroll; weights = :pw)
	@test getindex(h.plot.bins) == 15
	@test getindex(h.plot.weights) == dstrat.variables.pw

	h = svyhist(dstrat, :enroll; bins = 9, weights = :pw)
	@test getindex(h.plot.bins) == 9
	@test getindex(h.plot.weights) == dstrat.variables.pw

	h = svyhist(dstrat, :enroll; bins = :sturges, weights = :pw)
	@test getindex(h.plot.bins) == 9
	@test getindex(h.plot.weights) == dstrat.variables.pw

	h = svyhist(dstrat, :enroll; bins = [0, 1000, 2000, 3000], weights = :pw)
	@test getindex(h.plot.bins) == [0, 1000, 2000, 3000]
	@test getindex(h.plot.weights) == dstrat.variables.pw
end
