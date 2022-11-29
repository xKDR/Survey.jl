@testset "mean.jl" begin
    # SimpleRandomSample
    apisrs_original = load_data("apisrs")
    apisrs = copy(apisrs_original)
    
    srs = SimpleRandomSample(apisrs, popsize = apisrs.fpc)
    @test mean(:api00, srs).mean[1] == 656.585
    @test mean(:api00, srs).sem[1] ≈ 9.249722039282807
    @test mean(:enroll, srs).mean[1] ≈ 584.61
    @test mean(:enroll, srs).sem[1] ≈ 27.36836524766856
    
    apisrs = copy(apisrs_original)
    srs = SimpleRandomSample(apisrs, popsize=apisrs.fpc,ignorefpc = true)
    @test mean(:api00, srs).mean[1] == 656.585
    @test mean(:api00, srs).sem[1] ≈ 9.402772170880636

    # with fpc
    @test mean(:enroll, srs).mean[1] ≈ 584.61
    @test mean(:enroll, srs).sem[1] ≈ 27.821214737089324

    # srs_weights = SimpleRandomSample(apisrs, ignorefpc = false, weights = :fpc, probs = fill(0.3, size(apisrs_original, 1)))
    # @test mean(:enroll, srs_weights).mean[1] ≈ 584.61
    
    # Stratified Sample Tests
end


