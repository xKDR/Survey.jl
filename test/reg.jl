@testset "Binomial GLM in bsrs" begin
    rename!(bsrs.data, Symbol("sch.wide") => :sch_wide)
    bsrs.data.sch_wide = ifelse.(bsrs.data.sch_wide .== "Yes", 1, 0)
    model = svyglm(@formula(sch_wide ~ meals + ell), bsrs, Binomial())

    @test model.estimator[1] ≈ 1.523050676 rtol=STAT_TOL
    @test model.estimator[2] ≈ 0.009754261 rtol=STAT_TOL
    @test model.estimator[3] ≈ -0.020892044 rtol=STAT_TOL

    @test model.SE[1] ≈ 0.368055384 rtol=SE_TOL
    @test model.SE[2] ≈ 0.009798694 rtol=SE_TOL
    @test model.SE[3] ≈ 0.012806313 rtol=SE_TOL

    # R code
    # data(api)
    # srs <- svydesign(id=~dnum, weights=~pw, data=apisrs)
    # bsrs <- as.svrepdesign(srs, type="subbootstrap", replicates=10000)
    # model = svyglm(sch.wide ~ meals + ell, bsrs, family=binomial())
    # summary(model)
end

@testset "Gamma GLM in bsrs" begin
    model = svyglm(@formula(api00 ~ api99), bsrs, Gamma())

    @test model.estimator[1] ≈ 2.915479e-03 rtol=STAT_TOL
    @test model.estimator[2] ≈ -2.137187e-06 rtol=STAT_TOL
    @test model.SE[1] ≈ 4.581166e-05 rtol=SE_TOL
    @test model.SE[2] ≈ 6.520643e-08 rtol=SE_TOL
end

@testset "Normal GLM in bsrs" begin
    model = svyglm(@formula(api00 ~ api99), bsrs, Normal())

    @test model.estimator[1] ≈ 63.2830726 rtol=STAT_TOL
    @test model.estimator[2] ≈ 0.9497618 rtol=STAT_TOL
    @test model.SE[1] ≈ 9.64853456 rtol=SE_TOL
    @test model.SE[2] ≈ 0.01378683 rtol=SE_TOL
end

@testset "Poisson GLM in bsrs" begin
    rename!(bsrs.data, Symbol("api.stu") => :api_stu)
    model = svyglm(@formula(api_stu ~ meals + ell), bsrs, Poisson())

    @test model.estimator[1] ≈ 6.229602881 rtol=STAT_TOL
    @test model.estimator[2] ≈ -0.002038345 rtol=STAT_TOL
    @test model.estimator[3] ≈ 0.002116465 rtol=STAT_TOL

    @test model.SE[1] ≈ 0.093944656 rtol=SE_TOL
    @test model.SE[2] ≈ 0.002176296 rtol=SE_TOL
    @test model.SE[3] ≈ 0.002841031 rtol=SE_TOL
end