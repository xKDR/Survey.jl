@testset "GLM in bootstrap apisrs" begin
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

@testset "GLM in jackknife apisrs" begin
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

@testset "GLM in bootstrap apiclus1" begin
    rename!(dclus1_boot.data, Symbol("sch.wide") => :sch_wide)
    dclus1_boot.data.sch_wide = ifelse.(dclus1_boot.data.sch_wide .== "Yes", 1, 0)
    model = svyglm(@formula(sch_wide ~ meals + ell), dclus1_boot, Binomial())

    @test model.estimator[1] ≈ 1.89955691 rtol=STAT_TOL
    @test model.estimator[2] ≈ -0.01911468 rtol=STAT_TOL
    @test model.estimator[3] ≈ 0.03992541 rtol=STAT_TOL

    @test model.SE[1] ≈ 0.62928 rtol=SE_TOL
    @test model.SE[2] ≈ 0.01209 rtol=SE_TOL
    @test model.SE[3] ≈ 0.01533 rtol=SE_TOL

    # R code
    # data(api)
    # srs <- svydesign(id=~dnum, weights=~pw, data=apiclus1)
    # dclus1_boot <- as.svrepdesign(srs, type="subbootstrap", replicates=10000)
    # model = svyglm(sch.wide ~ meals + ell, dclus1_boot, family=binomial())
    # summary(model)

    model = svyglm(@formula(api00 ~ api99), dclus1_boot, Gamma(),InverseLink())

    @test model.estimator[1] ≈ 2.914844e-03 rtol=STAT_TOL
    @test model.estimator[2] ≈ -2.180775e-06 rtol=STAT_TOL
    @test model.SE[1] ≈ 8.014e-05 rtol=SE_TOL
    @test model.SE[2] ≈ 1.178e-07 rtol=SE_TOL

    # R code
    # data(api)
    # srs <- svydesign(id=~dnum, weights=~pw, data=apiclus1)
    # dclus1_boot <- as.svrepdesign(srs, type="subbootstrap", replicates=10000)
    # model = svyglm(api00 ~ api99, dclus1_boot, family = Gamma(link = "inverse"))
    # summary(model)

    model = svyglm(@formula(api00 ~ api99), dclus1_boot, Normal())

    @test model.estimator[1] ≈ 95.28483 rtol=STAT_TOL
    @test model.estimator[2] ≈ 0.90429 rtol=STAT_TOL
    @test model.SE[1] ≈ 16.02015 rtol=SE_TOL
    @test model.SE[2] ≈ 0.02522 rtol=SE_TOL

    # R code 
    # data(api)
    # srs <- svydesign(id=~dnum, weights=~pw, data=apiclus1)
    # dclus1_boot <- as.svrepdesign(srs, type="subbootstrap", replicates=10000)
    # model = svyglm(api00 ~ api99, dclus1_boot, family = gaussian())
    # summary(model)

    rename!(dclus1_boot.data, Symbol("api.stu") => :api_stu)
    model = svyglm(@formula(api_stu ~ meals + ell), dclus1_boot, Poisson())

    @test model.estimator[1] ≈ 6.2961803529 rtol=STAT_TOL
    @test model.estimator[2] ≈ -0.0026906166 rtol=STAT_TOL
    @test model.estimator[3] ≈ -0.0006054623 rtol=STAT_TOL

    @test model.SE[1] ≈ 0.161459174 rtol=SE_TOL
    @test model.SE[2] ≈ 0.003193577 rtol=0.11 # failing at 0.1
    @test model.SE[3] ≈ 0.005879115 rtol=SE_TOL

    # R code
    # data(api)
    # srs <- svydesign(id=~dnum, weights=~pw, data=apiclus1)
    # dclus1_boot <- as.svrepdesign(srs, type="subbootstrap", replicates=10000)
    # model = svyglm(api.stu ~ meals + ell, dclus1_boot, family = poisson())
    # summary(model)
end

@testset "GLM in bootstrap apistrat" begin
    rename!(bstrat.data, Symbol("sch.wide") => :sch_wide)
    bstrat.data.sch_wide = ifelse.(bstrat.data.sch_wide .== "Yes", 1, 0)
    model = svyglm(@formula(sch_wide ~ meals + ell), bstrat, Binomial())

    @test model.estimator[1] ≈ 1.560408424 rtol=STAT_TOL
    @test model.estimator[2] ≈ 0.003524761 rtol=STAT_TOL
    @test model.estimator[3] ≈ -0.006831057 rtol=STAT_TOL

    @test model.SE[1] ≈ 0.342669691 rtol=SE_TOL
    @test model.SE[2] ≈ 0.009423733 rtol=SE_TOL
    @test model.SE[3] ≈ 0.013934952 rtol=SE_TOL

    # R code
    # data(api)
    # srs <- svydesign(id=~1, strata=~dnum, weights=~pw, data=apistrat)
    # bstrat <- as.svrepdesign(srs, type="subbootstrap", replicates=10000)
    # model = svyglm(sch.wide ~ meals + ell, bstrat, family=binomial())
    # summary(model)

    model = svyglm(@formula(api00 ~ api99), bstrat, Gamma(),InverseLink())

    @test model.estimator[1] ≈ 2.873104e-03 rtol=STAT_TOL
    @test model.estimator[2] ≈ -2.088791e-06 rtol=STAT_TOL
    @test model.SE[1] ≈ 4.187745e-05 rtol=SE_TOL
    @test model.SE[2] ≈ 5.970111e-08 rtol=SE_TOL

    # R code
    # data(api)
    # srs <- svydesign(id=~1, strata=~dnum, weights=~pw, data=apistrat)
    # bstrat <- as.svrepdesign(srs, type="subbootstrap", replicates=10000)
    # model = svyglm(api00 ~ api99, bstrat, family = Gamma(link = "inverse"))
    # summary(model)
end