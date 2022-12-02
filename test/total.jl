@testset "total_SimpleRandomSample" begin
    apisrs_original = load_data("apisrs")
    # base functionality
    apisrs = copy(apisrs_original)
    srs = SimpleRandomSample(apisrs; popsize = :fpc)
    tot = total(:api00, srs)
    @test tot.total[1] ≈ 4.06688749e6 atol = 1e-4
    @test tot.se_total[1] ≈ 57292.7783113177 atol = 1e-4
	# CategoricalArray
    apisrs = copy(apisrs_original)
	apisrs[!, :cname] = CategoricalArrays.categorical(apisrs.cname)
    srs = SimpleRandomSample(apisrs; popsize = :fpc)
    tot = total(:cname, srs)
    @test size(tot)[1] == apisrs.cname |> unique |> length
	@test filter(:cname => ==("Alameda"), tot).total[1] ≈ 340.67 atol = 1e-2
	@test filter(:cname => ==("Alameda"), tot).se_tot[1] ≈ 98.472 atol = 1e-3
	@test filter(:cname => ==("Los Angeles"), tot).total[1] ≈ 1393.65 atol = 1e-2
	@test filter(:cname => ==("Los Angeles"), tot).se_tot[1] ≈ 180.368 atol = 1e-3
	# Vector{Symbol}
    apisrs = copy(apisrs_original)
    srs = SimpleRandomSample(apisrs; popsize = :fpc)
    tot = total([:api00, :enroll], srs)
	## :api00
    @test tot.total[1] ≈ 4066888 atol = 1
    @test tot.se_total[1] ≈ 57293 atol = 1
	## :enroll
    @test tot.total[2] ≈ 3621074 atol = 1
    @test tot.se_total[2] ≈ 169520 atol = 1
    # TODO: ignorefpc is not correct
    # # without fpc
    srs_ignorefpc = SimpleRandomSample(apisrs; popsize = :fpc, ignorefpc = true)
    tot = total(:api00, srs_ignorefpc)
    # @test tot.total[1] ≈ XXX
    # @test tot.se_total[1] ≈ XXX
end

@testset "total_Stratified" begin
    apistrat_original = load_data("apistrat")
    # base functionality
    apistrat = copy(apistrat_original)
    strat = StratifiedSample(apistrat, :stype; popsize = :fpc)
    tot = total(:api00, strat)
    @test tot.total[1] ≈ 4102208 atol = 1e-4
    @test tot.se_total[1] ≈ 57292.7783113177 atol = 1e-4
end

@testset "total_svyby_SimpleRandomSample" begin
    ## Add tests
end

@testset "total_svyby_Stratified" begin
    ## Add tests
end