@testset "jackknife.jl" begin
    apiclus1_original = load_data("apiclus1")
    apiclus1_original[!, :pw] = fill(757/15,(size(apiclus1_original,1),)) # Correct api mistake for pw column
    ##############################
    # one-stage cluster sample
    apiclus1 = copy(apiclus1_original)
    dclus1 = OneStageClusterSample(apiclus1, :dnum, :fpc)
    @test jkknife(:api00,dclus1, mean).SE[1] ≈ 26.5997 atol = 1e-4
    @test jkknife(:api00, dclus1, mean).Statistic[1] ≈ 644.1693 atol = 1e-4
end
