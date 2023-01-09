const STAT_TOL = 1e-5
const SE_TOL = 1e-1

@testset "Simple random sample" begin
    apisrs_original = load_data("apisrs")

    # base functionality
    apisrs = copy(apisrs_original)
    srs = SurveyDesign(apisrs; weights = :pw) |> bootweights
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

@testset "Stratified sample" begin
    apistrat_original = load_data("apistrat")

    # base functionality
    apistrat = copy(apistrat_original)
    strat = SurveyDesign(apistrat; strata = :stype, weights = :pw) |> bootweights
    tot = total(:api00, strat)
    @test tot.total[1] ≈ 4102208 rtol = STAT_TOL
    @test tot.SE[1] ≈ 60746 rtol = SE_TOL
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

@testset "One stage cluster sample" begin
    # Load API datasets
    apiclus1_original = load_data("apiclus1")
    apiclus1_original[!, :pw] = fill(757/15,(size(apiclus1_original,1),)) # Correct api mistake for pw column
    ##############################
    # one-stage cluster sample
    apiclus1 = copy(apiclus1_original)
    dclus1 = SurveyDesign(apiclus1, clusters = :dnum, weights = :pw) |> bootweights
    @test total(:api00,dclus1).total[1] ≈ 5949162 atol = 1
    @test total(:api00,dclus1).SE[1] ≈ 1.3338978891316957e6 atol = 1

    @test total(:api00, dclus1).total[1] ≈ 5949162 atol = 1
    @test total(:api00, dclus1).SE[1] ≈ 1352953 atol = 50000 # without fpc as it hasn't been figured out for bootstrap. 
    
end