@testset "svymean.jl" begin
    # SimpleRandomSample tests
    apisrs = load_data("apisrs")
    srs = SimpleRandomSample(apisrs, popsize = apisrs.fpc)
    @test svymean(:api00, srs).mean[1] == 656.585
    @test svymean(:api00, srs).sem[1] ≈ 9.249722039282807

    srs = SimpleRandomSample(apisrs, ignorefpc = true)
    @test svymean(:api00, srs).mean[1] == 656.585
    @test svymean(:api00, srs).sem[1] ≈ 9.402772170880636

    # Test with fpc

    # StratifiedSample tests
    # apistrat = load_data("apistrat")
    # strat = SimpleRandomSample(apistrat)
    # CHANGE WITH CORRECT VALUES
    # @test svymean(:api00, strat).mean[1] == 584.61
    # @test svymean(:api00, strat).sem[1] ≈ 27.82121473708932
end
