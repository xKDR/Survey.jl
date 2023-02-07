using GLM
@testset "GLM on simple random sample" begin
    repdesign = bootweights(srs; replicates = 500)
   @test glm(@formula(api00~api99), repdesign, Normal()).Coefficients ≈ coef(glm(@formula(api00~api99), repdesign.data, Normal()))
end