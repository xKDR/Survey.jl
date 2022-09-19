@testset "svytotal.jl" begin
    # SimpleRandomSample tests
    apisrs = load_data("apisrs")

    # Without fpc
    srs = SimpleRandomSample(apisrs, ignorefpc = true)
    tot = svytotal(:api00, srs)
    @test tot.total[1] == 131317.0
    @test tot.se_total[1] ≈ 1880.5544341761279

    # With fpc
    srs = SimpleRandomSample(apisrs, popsize = apisrs.fpc)
    tot = svytotal(:api00, srs)
    @test tot.total[1] ≈ 4.06688749e6
    @test tot.se_total[1] ≈ 57292.7783113177

    # StratifiedSample tests
    # apistrat = load_data("apistrat")
    # strat = StratifiedSample(apistrat, apistrat.stype)
    # tot = svytotal(:api00, strat)
    # CHANGE WITH CORRECT VALUES
    # @test tot.total[1] == 116922.0
    # @test tot.se_total[1] ≈ 5564.242947417864
end
