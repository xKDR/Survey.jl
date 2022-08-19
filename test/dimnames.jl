@testset "dimnames.jl" begin
    # Simple random sampling tests
    apisrs = load_data("apisrs")

    srs_new = SimpleRandomSample(apisrs)
    srs_old = svydesign(id = :1, data = apisrs)
    # `dim`
	@test dim(srs_new)[1] == dim(srs_old)[1]
	@test dim(srs_new)[2] == 43
	@test dim(srs_old)[2] == 45
    # `colnames`
	@test length(colnames(srs_new)) == dim(srs_new)[2]
	@test length(colnames(srs_old)) == dim(srs_old)[2]
    # `dimnames`
	@test length(dimnames(srs_new)[1]) == parse(Int, last(dimnames(srs_new)[1]))
	@test dimnames(srs_new)[2] == colnames(srs_new)
	@test length(dimnames(srs_old)[1]) == parse(Int, last(dimnames(srs_old)[1]))
	@test dimnames(srs_old)[2] == colnames(srs_old)

    # Stratified sampling tests
	apistrat = load_data("apistrat")

	dstrat = svydesign(data = apistrat, id = :1, strata = :stype, weights = :pw, fpc = :fpc)
    # `dim`
	@test dim(dstrat)[1] == 200
	@test dim(dstrat)[2] == size(dstrat.variables, 2)
    # `colnames`
	@test length(colnames(dstrat)) == dim(dstrat)[2]
    # `dimnames`
	@test length(dimnames(dstrat)[1]) == parse(Int, last(dimnames(dstrat)[1]))
	@test dimnames(dstrat)[2] == colnames(dstrat)
end
