using Survey
using Test

@testset "svyplot.jl" begin
	(; apistrat) = load_data(api)
	dstrat = svydesign(data = apistrat, id = :1, strata = :stype, weights = :pw, fpc = :fpc)
	s = svyplot(dstrat, :api99, :api00; weights = :pw)

	@test getindex(s.plot.markersize) == dstrat.variables[!, :pw]
end
