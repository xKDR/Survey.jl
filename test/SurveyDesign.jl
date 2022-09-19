@testset "SurveyDesign.jl" begin
    # SimpleRandomSample tests
    apisrs_original = load_data("apisrs")
    apisrs = copy(apisrs_original)

    srs = SimpleRandomSample(apisrs, popsize = apisrs.fpc)
    # @test srs.data.weights == ones(size(apisrs_original, 1))
    @test srs.data.weights == 1 ./ srs.data.probs # weights should be inverse of probs
    # THIS NEEDS TO BE CHANGED WHEN `sampsize` IS UPDATED
    # Write meaningful test for sample_size later
    @test srs.sampsize > 0

    # 16.06.22 shikhar add - this test should return error as popsize should be given if sampsize is given (for now)
    # srs_freq = SimpleRandomSample(apisrs; weights = fill(0.3, size(apisrs_original, 1)))
    # 16.06.22 shikhar add - this test fixes above test
    srs_freq = SimpleRandomSample(apisrs; popsize = apisrs.fpc , weights = fill(0.3, size(apisrs_original, 1)))
    @test srs_freq.data.weights[1] == 30.97
    @test srs_freq.data.weights == 1 ./ srs_freq.data.probs

    # This works but isnt what user is expecting
    srs_prob = SimpleRandomSample(apisrs; probs = fill(0.3, size(apisrs_original, 1)))
    @test srs_prob.data.probs[1] == 0.3
    # @test srs_prob.data.weights == ones(size(apisrs_original, 1))


    # StratifiedSample tests
    # apistrat = load_data("apistrat")
    # apistrat_copy = copy(apistrat)

    # strat = StratifiedSample(apistrat_copy, apistrat_copy.stype)
    # @test strat.data.strata == apistrat.stype
end
