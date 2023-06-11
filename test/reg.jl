@testset "Gamma GLM on bsrs" begin
    bsrs = bootweights(srs; replicates=1000)
    glm_model = glm(@formula(api00 ~ api99), bsrs.data, Gamma())
    svyglm_result = svyglm(@formula(api00 ~ api99), bsrs, Gamma())

    @test svyglm_result.Coefficients ≈ coef(glm_model) rtol=STAT_TOL
    #@test svyglm_result.SE[1] ≈ 9.77056319 rtol=SE_TOL
    #@test svyglm_result.SE[2] ≈ 0.01397871 rtol=SE_TOL
end