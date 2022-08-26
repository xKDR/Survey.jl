@testset "SurveyDesign.jl" begin
    # SimpleRandomSample tests
    apisrs_original = load_data("apisrs")
    apisrs = copy(apisrs_original)

    srs = SimpleRandomSample(apisrs)
    @test srs.data.weights == ones(size(apisrs_original, 1))
    @test srs.data.weights == srs.data.probs
    # THIS NEEDS TO BE CHANGED WHEN `sampsize` IS UPDATED
    @test srs.data.sampsize[1] == size(apisrs_original, 1)

    srs_freq = SimpleRandomSample(apisrs; weights = fill(0.3, size(apisrs_original, 1)))
    @test srs_freq.data.weights[1] == 0.3
    @test srs_freq.data.weights == 1 ./ srs_freq.data.probs

    srs_prob = SimpleRandomSample(apisrs; probs = fill(0.3, size(apisrs_original, 1)))
    @test srs_prob.data.probs[1] == 0.3
    @test srs_prob.data.weights == ones(size(apisrs_original, 1))


    # StratifiedSample tests
    apistrat = load_data("apistrat")
    apistrat_copy = copy(apistrat)

    strat = StratifiedSample(apistrat_copy, apistrat_copy.stype)
    @test strat.data.strata == apistrat.stype
end
