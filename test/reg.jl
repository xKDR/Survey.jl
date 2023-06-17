@testset "Binomial GLM in bsrs" begin
    model = svyglm(@formula(api_stu ~ meals + ell), bsrs, Binomial(), LogitLink())

    @test model.Coefficients[1] ≈  0.354808355 rtol=STAT_TOL
    @test model.Coefficients[2] ≈ 0.00321265 rtol=STAT_TOL
    @test model.Coefficients[3] ≈ -0.001055610 rtol=STAT_TOL

    @test model.SE[1] ≈ 0.28461771 rtol=SE_TOL
    @test model.SE[2] ≈ 0.00710232 rtol=SE_TOL
    @test model.SE[3] ≈ 0.01024790 rtol=SE_TOL
end

@testset "Gamma GLM in bsrs" begin
    model = svyglm(@formula(api00 ~ api99), bsrs, Gamma(), InverseLink())

    @test model.Coefficients[1] ≈ 2.915479e-03 rtol=STAT_TOL
    @test model.Coefficients[2] ≈ -2.137187e-06 rtol=STAT_TOL
    @test model.SE[1] ≈ 4.581166e-05 rtol=SE_TOL
    @test model.SE[2] ≈ 6.520643e-08 rtol=SE_TOL
end

@testset "Bernoulli GLM in bsrs" begin
    model = svyglm(@formula(awards ~ meals + ell), bsrs, Bernoulli(), LogitLink())

    @test model.Coefficients[1] ≈ 0.354808355 rtol=STAT_TOL
    @test model.Coefficients[2] ≈ 0.003212656 rtol=STAT_TOL
    @test model.Coefficients[3] ≈ -0.001055610 rtol=STAT_TOL

    @test model.SE[1] ≈ 0.28461771 rtol=SE_TOL
    @test model.SE[2] ≈ 0.00710232 rtol=SE_TOL
    @test model.SE[3] ≈ 0.01024790 rtol=SE_TOL
end

@testset "Poisson GLM in bsrs" begin
    model = svyglm(@formula(api_stu ~ meals + ell), bsrs, Poisson(), LogLink())

    @test model.Coefficients[1] ≈  0.354808355 rtol=STAT_TOL
    @test model.Coefficients[2] ≈ 0.00321265 rtol=STAT_TOL
    @test model.Coefficients[3] ≈ -0.001055610 rtol=STAT_TOL

    @test model.SE[1] ≈ 0.28461771 rtol=SE_TOL
    @test model.SE[2] ≈ 0.00710232 rtol=SE_TOL
    @test model.SE[3] ≈ 0.01024790 rtol=SE_TOL
end

