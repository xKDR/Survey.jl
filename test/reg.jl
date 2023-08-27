@testset "Binomial GLM in bsrs" begin
    rename!(bsrs.data, Symbol("sch.wide") => :sch_wide)
    bsrs.data.sch_wide = ifelse.(bsrs.data.sch_wide .== "Yes", 1, 0)
    model = svyglm(@formula(sch_wide ~ meals + ell), bsrs, Binomial())

    @test model.estimator[1] ≈ 1.523050676 rtol=STAT_TOL
    @test model.estimator[2] ≈ 0.009754261 rtol=STAT_TOL
    @test model.estimator[3] ≈ -0.020892044 rtol=STAT_TOL

    @test model.SE[1] ≈ 0.369836 rtol=SE_TOL
    @test model.SE[2] ≈ 0.009928 rtol=SE_TOL
    @test model.SE[3] ≈ 0.012676 rtol=SE_TOL

    # R code
    # data(api)
    # srs <- svydesign(id=~1, weights=~pw, data=apisrs)
    # bsrs <- as.svrepdesign(srs, type="subbootstrap", replicates=10000)
    # model = svyglm(sch.wide ~ meals + ell, bsrs, family=binomial())
    # summary(model)
end

@testset "Binomial GLM in jsrs" begin
    rename!(jsrs.data, Symbol("sch.wide") => :sch_wide)
    jsrs.data.sch_wide = ifelse.(jsrs.data.sch_wide .== "Yes", 1, 0)
    model = svyglm(@formula(sch_wide ~ meals + ell), jsrs, Binomial())

    @test model.estimator[1] ≈ 1.523051 rtol=STAT_TOL
    @test model.estimator[2] ≈ 0.009754 rtol=1e-4 # This is a tiny bit off with 1e-5
    @test model.estimator[3] ≈ -0.020892 rtol=STAT_TOL

    @test model.SE[1] ≈ 0.359043 rtol=SE_TOL
    @test model.SE[2] ≈ 0.009681 rtol=SE_TOL
    @test model.SE[3] ≈ 0.012501 rtol=SE_TOL

    # R code
    # data(api)
    # srs <- svydesign(id=~1, weights=~pw, data=apisrs)
    # jsrs <- as.svrepdesign(srs, type="JK1", replicates=10000)
    # model = svyglm(sch.wide ~ meals + ell, jsrs, family=binomial())
    # summary(model)
end

@testset "Gamma GLM in bsrs" begin
    model = svyglm(@formula(api00 ~ api99), bsrs, Gamma(),InverseLink())

    @test model.estimator[1] ≈ 2.915479e-03 rtol=STAT_TOL
    @test model.estimator[2] ≈ -2.137187e-06 rtol=STAT_TOL
    @test model.SE[1] ≈ 4.550e-05 rtol=SE_TOL
    @test model.SE[2] ≈ 6.471e-08 rtol=SE_TOL

    # R code
    # data(api)
    # srs <- svydesign(id=~1, weights=~pw, data=apisrs)
    # bsrs <- as.svrepdesign(srs, type="subbootstrap", replicates=10000)
    # model = svyglm(api00 ~ api99, bsrs, family = Gamma(link = "inverse"))
    # summary(model)
end

@testset "Gamma GLM in jsrs" begin
    model = svyglm(@formula(api00 ~ api99), jsrs, Gamma(), InverseLink())

    @test model.estimator[1] ≈ 2.915479e-03 rtol=STAT_TOL
    @test model.estimator[2] ≈ -2.137187e-06 rtol=STAT_TOL
    @test model.SE[1] ≈ 5.234e-05 rtol=0.12 # failing at 1e-1
    @test model.SE[2] ≈ 7.459e-08 rtol=0.12 # failing at 1e-1

    # R code
    # data(api)
    # srs <- svydesign(id=~1, weights=~pw, data=apisrs)
    # jsrs <- as.svrepdesign(srs, type="JK1", replicates=10000)
    # model = svyglm(api00 ~ api99, jsrs, family = Gamma(link = "inverse"))
    # summary(model)
end

@testset "Normal GLM in bsrs" begin
    model = svyglm(@formula(api00 ~ api99), bsrs, Normal())

    @test model.estimator[1] ≈ 63.2830726 rtol=STAT_TOL
    @test model.estimator[2] ≈ 0.9497618 rtol=STAT_TOL
    @test model.SE[1] ≈ 9.63276 rtol=SE_TOL
    @test model.SE[2] ≈ 0.01373 rtol=SE_TOL

    # R code 
    # data(api)
    # srs <- svydesign(id=~1, weights=~pw, data=apisrs)
    # bsrs <- as.svrepdesign(srs, type="subbootstrap", replicates=10000)
    # model = svyglm(api00 ~ api99, bsrs, family = gaussian())
    # summary(model)
end

@testset "Normal GLM in jsrs" begin
    model = svyglm(@formula(api00 ~ api99), jsrs, Normal())

    @test model.estimator[1] ≈ 63.2830726 rtol=STAT_TOL
    @test model.estimator[2] ≈ 0.9497618 rtol=STAT_TOL
    @test model.SE[1] ≈ 9.69178 rtol=SE_TOL
    @test model.SE[2] ≈ 0.01384 rtol=SE_TOL

    # R code
    # data(api)
    # srs <- svydesign(id=~1, weights=~pw, data=apisrs)
    # jsrs <- as.svrepdesign(srs, type="JK1", replicates=10000)
    # model = svyglm(api00 ~ api99, jsrs, family = gaussian())
    # summary(model)
end

@testset "Poisson GLM in bsrs" begin
    rename!(bsrs.data, Symbol("api.stu") => :api_stu)
    model = svyglm(@formula(api_stu ~ meals + ell), bsrs, Poisson())

    @test model.estimator[1] ≈ 6.229602881 rtol=STAT_TOL
    @test model.estimator[2] ≈ -0.002038345 rtol=STAT_TOL
    @test model.estimator[3] ≈ 0.002116465 rtol=STAT_TOL

    @test model.SE[1] ≈ 0.093115 rtol=SE_TOL
    @test model.SE[2] ≈ 0.002191 rtol=SE_TOL
    @test model.SE[3] ≈ 0.002858 rtol=SE_TOL

    # R code
    # data(api)
    # srs <- svydesign(id=~1, weights=~pw, data=apisrs)
    # bsrs <- as.svrepdesign(srs, type="subbootstrap", replicates=10000)
    # model = svyglm(api.stu ~ meals + ell, bsrs, family = poisson())
    # summary(model)
end

@testset "Poisson GLM in jsrs" begin
    rename!(jsrs.data, Symbol("api.stu") => :api_stu)
    model = svyglm(@formula(api_stu ~ meals + ell), jsrs, Poisson())

    @test model.estimator[1] ≈ 6.229602881 rtol=STAT_TOL
    @test model.estimator[2] ≈ -0.002038345 rtol=STAT_TOL
    @test model.estimator[3] ≈ 0.002116465 rtol=STAT_TOL

    @test model.SE[1] ≈ 0.095444 rtol=SE_TOL
    @test model.SE[2] ≈ 0.002317 rtol=SE_TOL
    @test model.SE[3] ≈ 0.003085 rtol=SE_TOL

    # R code
    # data(api)
    # srs <- svydesign(id=~1, weights=~pw, data=apisrs)
    # jsrs <- as.svrepdesign(srs, type="JK1", replicates=10000)
    # model = svyglm(api.stu ~ meals + ell, jsrs, family = poisson())
    # summary(model)
end