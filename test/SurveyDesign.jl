@testset "SurveyDesign.jl" begin
    # SimpleRandomSample tests
    apisrs = load_data("apisrs")

    srs = SimpleRandomSample(apisrs)
    @test size(srs.data, 2) - size(apisrs, 2) == 3
    @test srs.data.weights == ones(size(apisrs, 1))
    @test srs.data.weights == srs.data.probs
    # THIS NEEDS TO BE CHANGED WHEN `sampsize` IS UPDATED
    @test srs.data.sampsize[1] == size(apisrs, 1)

    srs_weighted_freq = SimpleRandomSample(apisrs; weights = repeat([0.3], size(apisrs, 1)))
    @test srs_weighted_freq.data.weights[1] == 0.3
    @test srs_weighted_freq.data.weights == 1 ./ srs_weighted_freq.data.probs

    srs_weighted_prob = SimpleRandomSample(apisrs; probs = repeat([0.3], size(apisrs, 1)))
    @test srs_weighted_prob.data.probs[1] == 0.3
    @test srs_weighted_prob.data.weights == ones(size(apisrs, 1))
end
