@testset "ratio.jl" begin
    apiclus1_original = load_data("apiclus1")
    apiclus1_original[!, :pw] = fill(757/15,(size(apiclus1_original,1),)) # Correct api mistake for pw column
    ##############################
    # one-stage cluster sample
    apiclus1 = copy(apiclus1_original)
    dclus1 = SurveyDesign(apiclus1, :dnum, :fpc)
    @test ratio(:api00, :enroll, dclus1).SE[1] ≈ 0.151242 atol = 1e-4
    @test ratio(:api00, :enroll, dclus1).Statistic[1] ≈ 1.17182 atol = 1e-4
end