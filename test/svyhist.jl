using Survey
using Test

@testset "svyhist.jl" begin
	data(api)
	dstrat = svydesign(data = apistrat, id = :1, strata = :stype, weights = :pw, fpc = :fpc)
	h = svyhist(dstrat, :enroll, weights = :pw)

	@test getindex(h.plot.bins) == 9
	@test getindex(h.plot.weights) == dstrat.variables.pw
end
