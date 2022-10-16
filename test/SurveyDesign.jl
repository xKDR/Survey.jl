@testset "SurveyDesign.jl" begin
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

    # StratifiedSample tests
end
