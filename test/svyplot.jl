using Survey
using Test

@testset "svyplot.jl" begin
	apistrat = load_data("apistrat")
	dstrat = svydesign(data = apistrat, id = :1, strata = :stype, weights = :pw, fpc = :fpc)
	s = svyplot(dstrat, :api99, :api00)

	@test s.grid[1].entries[1].named[:markersize] == dstrat.variables.weights
	@test s.grid[1].entries[1].positional[1] == dstrat.variables.api99
	@test s.grid[1].entries[1].positional[2] == dstrat.variables.api00
end
