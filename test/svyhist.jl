using Survey
using Test

import Survey: freedman_diaconis, sturges

@testset "svyhist.jl" begin
	data(api)
	dstrat = svydesign(data = apistrat, id = :1, strata = :stype, weights = :pw, fpc = :fpc)

	@test sturges(10) == 5
	@test sturges([1, 2, 5, 10, 15, 17, 20]) == 4

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
