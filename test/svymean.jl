@testset "svymean.jl" begin
    # SimpleRandomSample tests
    apisrs = load_data("apisrs")
    srs = SimpleRandomSample(apisrs)
    @test svymean(:api00, srs).mean[1] == 656.585
    @test svymean(:api00, srs).sem[1] ≈ 9.40277217088064


    # StratifiedSample tests
    # apistrat = load_data("apistrat")
    # strat = SimpleRandomSample(apistrat)
    # CHANGE WITH CORRECT VALUES
    # @test svymean(:api00, strat).mean[1] == 584.61
    # @test svymean(:api00, strat).sem[1] ≈ 27.82121473708932
end
