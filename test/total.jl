@testset "total_SimpleRandomSample" begin
    apisrs_original = load_data("apisrs")
    # base functionality
    apisrs = copy(apisrs_original)
    srs = SimpleRandomSample(apisrs; popsize = :fpc)
    tot = total(:api00, srs)
    @test tot.total[1] ≈ 4.06688749e6 atol = 1e-4
    @test tot.se_total[1] ≈ 57292.7783113177 atol = 1e-4
    # without fpc
    srs_ignorefpc = SimpleRandomSample(apisrs; popsize = :fpc, ignorefpc = true)
    tot = total(:api00, srs_ignorefpc)
    # TODO: uncomment after correcting `total` function
    # @test tot.total[1] ≈ 131317 atol = 1
    # @test tot.se_total[1] ≈ 1880.6 atol = 1e-1
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
end

@testset "total_Stratified" begin
    apistrat_original = load_data("apistrat")
    # base functionality
    apistrat = copy(apistrat_original)
    strat = StratifiedSample(apistrat, :stype; popsize = :fpc)
    tot = total(:api00, strat)
    @test tot.total[1] ≈ 4102208 atol = 1e-1
    @test tot.SE[1] ≈ 58279 atol = 1e-1
    # without fpc
    strat_ignorefpc = StratifiedSample(apistrat, :stype; popsize = :fpc, ignorefpc = true)
    tot = total(:api00, strat_ignorefpc)
    @test tot.total[1] ≈ 130564 atol = 1e-4
    # TODO: uncomment after correcting `total` function
    # @test tot.SE[1] ≈ 1690.4 atol = 1e-1
    # CategoricalArray
    apistrat = copy(apistrat_original)
    apistrat[!, :cname] = CategoricalArrays.categorical(apistrat.cname)
    strat = StratifiedSample(apistrat, :stype; popsize = :fpc)
    # TODO: uncomment after adding `CategoricalArray` support
    # @test tot.SE[1] ≈ 1690.4 atol = 1e-1
    # tot = total(:cname, strat)
    # @test size(tot)[1] == apistrat.cname |> unique |> length
    # @test filter(:cname => ==("Kern"), tot).total[1] ≈ 291.97 atol = 1e-2
    # @test filter(:cname => ==("Kern"), tot).se_tot[1] ≈ 101.760 atol = 1e-3
    # @test filter(:cname => ==("Los Angeles"), tot).total[1] ≈ 1373.15 atol = 1e-2
    # @test filter(:cname => ==("Los Angeles"), tot).se_tot[1] ≈ 199.635 atol = 1e-3
    # Vector{Symbol}
    apistrat = copy(apistrat_original)
    strat = StratifiedSample(apistrat, :stype; popsize = :fpc)
    tot = total([:api00, :enroll], strat)
    ## :api00
    @test tot.total[1] ≈ 4102208 atol = 1
    @test tot.se_total[1] ≈ 58279 atol = 1
    ## :enroll
    @test tot.total[2] ≈ 3687178 atol = 1
    @test tot.se_total[2] ≈ 114642 atol = 1
end

@testset "total_svyby_SimpleRandomSample" begin
    ## Add tests
end

@testset "total_svyby_Stratified" begin
    ## Add tests
end