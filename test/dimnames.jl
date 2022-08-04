using Survey
using Test

@testset "dimnames.jl" begin
	apistrat = load_data("apistrat")
	dstrat = svydesign(data = apistrat, id = :1, strata = :stype, weights = :pw, fpc = :fpc)

	@test dim(dstrat)[1] == 200
	@test dim(dstrat)[2] == size(dstrat.variables, 2)

	@test length(colnames(dstrat)) == dim(dstrat)[2]

	@test length(dimnames(dstrat)[1]) == parse(Int, last(dimnames(dstrat)[1]))
	@test dimnames(dstrat)[2] == colnames(dstrat)
end
