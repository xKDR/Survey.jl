@testset "Normal GLM on bootstrap simple random sample survey" begin
    glm_model = glm(@formula(api00 ~ api99), bsrs.data, Normal())
    svyglm_result = svyglm(@formula(api00 ~ api99), bsrs, Normal())

    @test svyglm_result.Coefficients ≈ coef(glm_model) rtol=STAT_TOL
    @test svyglm_result.SE ≈ stderror(glm_model) rtol=SE_TOL
end