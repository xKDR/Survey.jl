@testset "SimpleRandomSample" begin
    # SimpleRandomSample tests
    apisrs_original = load_data("apisrs")
    apisrs = copy(apisrs_original)

    srs = SimpleRandomSample(apisrs, popsize = apisrs.fpc)
    @test srs.data.weights == 1 ./ srs.data.probs # weights should be inverse of probs
    @test srs.sampsize > 0

    srs_freq = SimpleRandomSample(apisrs; popsize = apisrs.fpc , weights = fill(0.3, size(apisrs_original, 1)))
    @test srs_freq.data.weights[1] == 30.97
    @test srs_freq.data.weights == 1 ./ srs_freq.data.probs

    # TODO: needs change; this works but isn't what the user is expecting
    srs_prob = SimpleRandomSample(apisrs; probs = fill(0.3, size(apisrs_original, 1)))
    @test srs_prob.data.probs[1] == 0.3
    @test srs_prob.data.weights == 1 ./ srs_prob.data.probs

    srs = SimpleRandomSample(apisrs, ignorefpc = true, weights = :pw )
    @test srs.data.probs == 1 ./ srs.data.weights
    
    srs = SimpleRandomSample(apisrs, ignorefpc = false, weights = :pw)
    @test srs.data.probs == 1 ./ srs.data.weights

    srs_weights = SimpleRandomSample(apisrs, ignorefpc = false, weights = :fpc)
    @test_throws srs_weights = SimpleRandomSample(apisrs, ignorefpc = false, weights = :stype)
    srs_w_p = SimpleRandomSample(apisrs, ignorefpc = false, weights = :fpc, probs = fill(0.3, size(apisrs_original, 1)))

    srs = SimpleRandomSample(apisrs, ignorefpc = true, probs = 1 ./ apisrs.pw )
    @test srs.data.probs == 1 ./ srs.data.weights
    srs = SimpleRandomSample(apisrs, popsize = -2.8, ignorefpc = true)# the errror is wrong
    srs = SimpleRandomSample(apisrs, sampsize = -2.8, ignorefpc = true)# the function is working upto line 55

end

@testset "StratifiedSample" begin
  # StratifiedSample tests   
end