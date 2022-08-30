@testset "svytotal.jl" begin
    # SimpleRandomSample tests
    apisrs = load_data("apisrs")
    srs = SimpleRandomSample(apisrs)
    tot = svytotal(:api00, srs)
    @test tot.total[1] == 131317.0
    @test tot.se_total[1] ≈ 1880.5544341761279

    # StratifiedSample tests
    # apistrat = load_data("apistrat")
    # strat = StratifiedSample(apistrat, apistrat.stype)
    # tot = svytotal(:api00, strat)
    # CHANGE WITH CORRECT VALUES
    # @test tot.total[1] == 116922.0
    # @test tot.se_total[1] ≈ 5564.242947417864
end
