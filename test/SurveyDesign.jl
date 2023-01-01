@testset "SurveyDesign" begin
    # Load API datasets
    apiclus1_original = load_data("apiclus1")
    apiclus1_original[!, :pw] = fill(757/15,(size(apiclus1_original,1),)) # Correct api mistake for pw column
    ##############################
    # one-stage cluster sample with popsize
    apiclus1 = copy(apiclus1_original)
    dclus1 = SurveyDesign(apiclus1; clusters = :dnum, popsize =:fpc)
    @test dclus1.data[!, :weights] ≈ fill(50.4667,size(apiclus1,1)) atol = 1e-3
    @test dclus1.data[!,dclus1.sampsize] ≈ fill(15,size(apiclus1,1))
    @test dclus1.data[!,:allprobs] ≈ dclus1.data[!,:probs] atol = 1e-4
end