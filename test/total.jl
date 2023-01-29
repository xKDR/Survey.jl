const STAT_TOL = 1e-5
const SE_TOL = 1e-1

@testset "total SRS" begin
    apisrs = load_data("apisrs")
    srs = SurveyDesign(apisrs; weights = :pw) |> bootweights

    # base functionality
    tot = total(:api00, srs)
    @test tot.total[1] ≈ 4066888 rtol = STAT_TOL
    @test tot.SE[1] ≈ 58526 rtol = SE_TOL
    mn = mean(:api00, srs)
    @test mn.mean[1] ≈ 656.58 rtol = STAT_TOL
    @test mn.SE[1] ≈ 9.4488 rtol = SE_TOL
    # equivalent R code and results:
    # > srs <- svydesign(data=apisrs, id=~1, weights=~pw)
    # > srsrep <- as.svrepdesign(srs, type="bootstrap", replicates=4000)
    # > svytotal(~api00, srsrep)
    #         total    SE
    # api00 4066888 58526
    # > svymean(~api00, srsrep)
    #         mean     SE
    # api00 656.58 9.4488

    # Vector{Symbol}
    tot = total([:api00, :enroll], srs)
    mn = mean([:api00, :enroll], srs)
    ## :api00
    @test tot.total[1] ≈ 4066888 rtol = STAT_TOL
    @test tot.SE[1] ≈ 57502 rtol = SE_TOL
    @test mn.mean[1] ≈ 656.58 rtol = STAT_TOL
    @test mn.SE[1] ≈ 9.2835 rtol = SE_TOL
    ## :enroll
    @test tot.total[2] ≈ 3621074 rtol = STAT_TOL
    @test tot.SE[2] ≈ 176793 rtol = SE_TOL
    @test mn.mean[2] ≈ 584.61 rtol = STAT_TOL
    @test mn.SE[2] ≈ 28.5427 rtol = SE_TOL
    # equivalent R code and results:
    # > svytotal(~api00+~enroll, srsrep)
    #         total     SE
    # api00  4066888  57502
    # enroll 3621074 176793
    # > svymean(~api00+~enroll, srsrep)
    #         mean      SE
    # api00  656.58  9.2835
    # enroll 584.61 28.5427

    # subpopulation
    tot = total(:api00, :cname, srs)
    @test size(tot)[1] == apisrs.cname |> unique |> length
    @test filter(:cname => ==("Los Angeles"), tot).total[1] ≈ 917238.49 rtol = STAT_TOL
    @test filter(:cname => ==("Los Angeles"), tot).SE[1] ≈ 122193.02 rtol = SE_TOL
    @test filter(:cname => ==("Monterey"), tot).total[1] ≈ 74947.40 rtol = STAT_TOL
    @test filter(:cname => ==("Monterey"), tot).SE[1] ≈ 38862.71 rtol = SE_TOL
    mn = mean(:api00, :cname, srs)
    @test size(mn)[1] == apisrs.cname |> unique |> length
    @test filter(:cname => ==("Los Angeles"), mn).mean[1] ≈ 658.1556 rtol = STAT_TOL
    @test filter(:cname => ==("Los Angeles"), mn).SE[1] ≈ 2.126852e+01 rtol = SE_TOL
    @test filter(:cname => ==("Santa Clara"), mn).mean[1] ≈ 718.2857 rtol = STAT_TOL
    @test filter(:cname => ==("Santa Clara"), mn).SE[1] ≈ 5.835346e+01 rtol = SE_TOL
    # equivalent R code (results cause clutter):
    # > svyby(~api00, ~cname, srsrep, svytotal)
    # > svyby(~api00, ~cname, srsrep, svymean)
end

@testset "total Stratified" begin
    apistrat = load_data("apistrat")
    strat = SurveyDesign(apistrat; strata = :stype, weights = :pw) |> bootweights

    # base functionality
    tot = total(:api00, strat)
    @test tot.total[1] ≈ 4102208 rtol = STAT_TOL
    @test tot.SE[1] ≈ 60746 rtol = SE_TOL
    mn = mean(:api00, strat)
    @test mn.mean[1] ≈ 662.29 rtol = STAT_TOL
    @test mn.SE[1] ≈ 9.8072 rtol = SE_TOL
    # equivalent R code and results:
    # > strat <- svydesign(data=apistrat, id=~1, weights=~pw, strata=~stype)
    # > stratrep <- as.svrepdesign(strat, type="bootstrap", replicates=4000)
    # > svytotal(~api00, stratrep)
    #     total    SE
    # api00 4102208 60746
    # > svymean(~api00, stratrep)
    #     mean     SE
    # api00 662.29 9.8072

    # Vector{Symbol}
    tot = total([:api00, :enroll], strat)
    mn = mean([:api00, :enroll], strat)
    ## :api00
    @test tot.total[1] ≈ 4102208 rtol = STAT_TOL
    @test tot.SE[1] ≈ 60746 rtol = SE_TOL
    @test mn.mean[1] ≈ 662.29 rtol = STAT_TOL
    @test mn.SE[1] ≈ 9.8072 rtol = SE_TOL
    ## :enroll
    @test tot.total[2] ≈ 3687178 rtol = STAT_TOL
    @test tot.SE[2] ≈ 117322 rtol = SE_TOL
    @test mn.mean[2] ≈ 595.28 rtol = STAT_TOL
    @test mn.SE[2] ≈ 18.9412 rtol = SE_TOL
    # equivalent R code and results:
    # > svytotal(~api00+~enroll, stratrep)
    # > svymean(~api00+~enroll, stratrep)
    #         mean      SE
    # api00  662.29  9.8072
    # enroll 595.28 18.9412

    # subpopulation
    tot = total(:api00, :cname, strat)
    @test size(tot)[1] == apistrat.cname |> unique |> length
    @test filter(:cname => ==("Los Angeles"), tot).total[1] ≈ 869905.98 rtol = STAT_TOL
    @test filter(:cname => ==("Los Angeles"), tot).SE[1] ≈ 134195.81 rtol = SE_TOL
    @test filter(:cname => ==("Monterey"), tot).total[1] ≈ 72103.09 rtol = STAT_TOL
    @test filter(:cname => ==("Monterey"), tot).SE[1] ≈ 45532.88 rtol = SE_TOL
    mn = mean(:api00, :cname, strat)
    @test size(mn)[1] == apistrat.cname |> unique |> length
    @test filter(:cname => ==("Los Angeles"), mn).mean[1] ≈ 633.5113 rtol = STAT_TOL
    @test filter(:cname => ==("Los Angeles"), mn).SE[1] ≈ 21.681068 rtol = SE_TOL
    @test filter(:cname => ==("Santa Clara"), mn).mean[1] ≈ 664.1212 rtol = STAT_TOL
    @test filter(:cname => ==("Santa Clara"), mn).SE[1] ≈ 48.817277 rtol = SE_TOL
    # equivalent R code (results cause clutter):
    # > svyby(~api00, ~cname, stratrep, svytotal)
    # > svyby(~api00, ~cname, stratrep, svymean)
end

@testset "total Cluster" begin
    apiclus1 = load_data("apiclus1")
    clus1 = SurveyDesign(apiclus1, clusters = :dnum, weights = :pw) |> bootweights

    # base functionality
    tot = total(:api00, clus1)
    @test tot.total[1] ≈ 3989986 rtol = STAT_TOL
    @test tot.SE[1] ≈ 900323 rtol = SE_TOL
    mn = mean(:api00, clus1)
    @test mn.mean[1] ≈ 644.17 rtol = STAT_TOL
    @test mn.SE[1] ≈ 23.534 rtol = SE_TOL
    # equivalent R code and results:
    # > clus1 <- svydesign(data=apiclus1, id=~dnum, weights=~pw)
    # > clus1rep <- as.svrepdesign(clus1, type="bootstrap", replicates=4000)
    # > svytotal(~api00, clus1rep)
    #         total     SE
    # api00 3989986 900323
    # > svymean(~api00, clus1rep)
    #         mean     SE
    # api00 644.17 23.534

    # Vector{Symbol}
    tot = total([:api00, :enroll], clus1)
    mn = mean([:api00, :enroll], clus1)
    ## :api00
    @test tot.total[1] ≈ 3989986 rtol = STAT_TOL
    @test tot.SE[1] ≈ 900323 rtol = SE_TOL
    @test mn.mean[1] ≈ 644.17 rtol = STAT_TOL
    @test mn.SE[1] ≈ 23.534 rtol = SE_TOL
    ## :enroll
    @test tot.total[2] ≈ 3404940 rtol = STAT_TOL
    @test tot.SE[2] ≈ 941501 rtol = SE_TOL
    @test mn.mean[2] ≈ 549.72 rtol = STAT_TOL
    @test mn.SE[2] ≈ 46.070 rtol = SE_TOL
    # equivalent R code and results:
    # > svytotal(~api00+~enroll, clus1rep)
    #     total     SE
    # api00  3989986 900323
    # enroll 3404940 941501
    # > svymean(~api00+~enroll, clus1rep)
    #     mean     SE
    # api00  644.17 23.534
    # enroll 549.72 46.070

    # subpopulation
    tot = total(:api00, :cname, clus1)
    @test size(tot)[1] == apiclus1.cname |> unique |> length
    @test filter(:cname => ==("Los Angeles"), tot).total[1] ≈ 328620.49 rtol = STAT_TOL
    @test filter(:cname => ==("Los Angeles"), tot).SE[1] ≈ 292840.83 rtol = SE_TOL
    @test filter(:cname => ==("San Diego"), tot).total[1] ≈ 1227596.71 rtol = STAT_TOL
    @test filter(:cname => ==("San Diego"), tot).SE[1] ≈ 860028.39 rtol = SE_TOL
    # equivalent R code (results cause clutter):
    # > svyby(~api00, ~cname, clus1rep, svytotal)
    # > svyby(~api00, ~cname, clus1rep, svymean)
end