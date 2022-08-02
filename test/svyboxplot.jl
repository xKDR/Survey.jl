using Survey
using Test

@testset "svyplot.jl" begin
	data(api)
	dstrat = svydesign(data = apistrat, id = :1, strata = :stype, weights = :pw, fpc = :fpc)
	bp = svyboxplot(dstrat, :stype, :enroll; weights = :pw)

	@test bp.grid[1].entries[1].positional[2] == dstrat.variables[!, :enroll]
	@test bp.grid[1].entries[1].named[:weights] == dstrat.variables[!, :pw]
end
