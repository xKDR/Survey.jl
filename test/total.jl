@testset "Simple random sample" begin
    apisrs_original = load_data("apisrs")

    # base functionality
    apisrs = copy(apisrs_original)
    srs = SurveyDesign(apisrs; weights = :pw) |> bootweights
    tot = total(:api00, srs)
    @test tot.total[1] ≈ 4066888 rtol = 1e-5
    @test tot.SE[1] ≈ 58526 rtol = 1e-1
    mn = mean(:api00, srs)
    @test mn.mean[1] ≈ 656.58 rtol = 1e-5
    @test mn.SE[1] ≈ 9.4488 rtol = 1e-1
    # equivalent R code and results:
    # > srs <- svydesign(data=apisrs, id=~1, weights=~pw)
    # > srsrep <- as.svrepdesign(srs, type="bootstrap", replicates=4000)
    # > svytotal(~api00, srsrep)
    #         total    SE
    # api00 4066888 58526
    # > svymean(~api00, srsrep)
    #         mean     SE
    # api00 656.58 9.4488

    # CategoricalArray
    # apisrs = copy(apisrs_original)
    # apisrs[!, :cname] = CategoricalArrays.categorical(apisrs.cname)
    # srs = SurveyDesign(apisrs; popsize = :fpc)
    # tot = total(:cname, srs)
    # @test size(tot)[1] == apisrs.cname |> unique |> length
    # @test filter(:cname => ==("Alameda"), tot).total[1] ≈ 340.67 atol = 1e-2
    # @test filter(:cname => ==("Alameda"), tot).SE[1] ≈ 98.472 atol = 1e-3
    # @test filter(:cname => ==("Los Angeles"), tot).total[1] ≈ 1393.65 atol = 1e-2
    # @test filter(:cname => ==("Los Angeles"), tot).SE[1] ≈ 180.368 atol = 1e-3

    # Vector{Symbol}
    apisrs = copy(apisrs_original)
    srs = SurveyDesign(apisrs; weights = :pw) |> bootweights
    tot = total([:api00, :enroll], srs)
    mn = mean([:api00, :enroll], srs)
    ## :api00
    @test tot.total[1] ≈ 4066888 rtol = 1e-5
    @test tot.SE[1] ≈ 57502 rtol = 1e-1
    @test mn.mean[1] ≈ 656.58 rtol = 1e-5
    @test mn.SE[1] ≈ 9.2835 rtol = 1e-1
    ## :enroll
    @test tot.total[2] ≈ 3621074 rtol = 1e-5
    @test tot.SE[2] ≈ 176793 rtol = 1e-1
    @test mn.mean[2] ≈ 584.61 rtol = 1e-5
    @test mn.SE[2] ≈ 28.5427 rtol = 1e-1
    # equivalent R code and results:
    # > srs <- svydesign(data=apisrs, id=~1, weights=~pw)
    # > srsrep <- as.svrepdesign(srs, type="bootstrap", replicates=4000)
    # > svytotal(~api00+~enroll, srsrep)
    #         total     SE
    # api00  4066888  57502
    # enroll 3621074 176793
    # > svymean(~api00+~enroll, srsrep)
    #         mean      SE
    # api00  656.58  9.2835
    # enroll 584.61 28.5427

    # subpopulation
    apisrs = copy(apisrs_original)
    srs = SurveyDesign(apisrs; weights = :pw) |> bootweights
    tot = total(:api00, :cname, srs)
    @test size(tot)[1] == apisrs.cname |> unique |> length
    @test filter(:cname => ==("Los Angeles"), tot).total[1] ≈ 917238.49 rtol = 1e-5
    @test filter(:cname => ==("Los Angeles"), tot).SE[1] ≈ 122193.02 rtol = 1e-1
    @test filter(:cname => ==("Monterey"), tot).total[1] ≈ 74947.40 rtol = 1e-5
    @test filter(:cname => ==("Monterey"), tot).SE[1] ≈ 38862.71 rtol = 1e-1
    mn = mean(:api00, :cname, srs)
    @test size(mn)[1] == apisrs.cname |> unique |> length
    @test filter(:cname => ==("Los Angeles"), mn).mean[1] ≈ 658.1556 rtol = 1e-5
    @test filter(:cname => ==("Los Angeles"), mn).SE[1] ≈ 2.126852e+01 rtol = 1e-1
    @test filter(:cname => ==("Santa Clara"), mn).mean[1] ≈ 718.2857 rtol = 1e-5
    @test filter(:cname => ==("Santa Clara"), mn).SE[1] ≈ 5.835346e+01 rtol = 1e-1
    # equivalent R code and results:
    # > srs <- svydesign(data=apisrs, id=~1, weights=~pw)
    # > srsrep <- as.svrepdesign(srs, type="bootstrap", replicates=4000)
    # > svyby(~api00, ~cname, srsrep, svytotal)
    #                         cname    api00           se
    # Alameda                 Alameda 230323.89  67808.91
    # Calaveras             Calaveras  24466.30  24199.26
    # Contra Costa       Contra Costa 213538.15  68780.65
    # Fresno                   Fresno 148717.94  54174.78
    # Imperial               Imperial  19263.34  19292.34
    # Kern                       Kern 177643.92  56429.75
    # Kings                     Kings  29080.83  20659.88
    # Lake                       Lake  24899.88  24796.24
    # Lassen                   Lassen  23289.44  23150.91
    # Los Angeles         Los Angeles 917238.49 122193.02
    # Madera                   Madera  44596.80  25684.62
    # Marin                     Marin  74297.03  43018.64
    # Merced                   Merced  18427.15  18057.21
    # Modoc                     Modoc  20780.87  20977.35
    # Monterey               Monterey  74947.40  38862.71
    # Napa                       Napa  45030.38  31747.05
    # Orange                   Orange 208861.68  66824.94
    # Placer                   Placer  23506.23  23426.32
    # Riverside             Riverside 177860.71  55697.57
    # Sacramento           Sacramento 152620.16  53266.09
    # San Bernardino   San Bernardino 247388.36  66806.58
    # San Diego             San Diego 254387.58  71730.93
    # San Francisco     San Francisco  51874.75  29597.88
    # San Joaquin         San Joaquin 113102.44  46195.42
    # San Luis Obispo San Luis Obispo  22886.83  22984.23
    # San Mateo             San Mateo  38216.98  27075.67
    # Santa Barbara     Santa Barbara  67700.42  38550.72
    # Santa Clara         Santa Clara 155717.16  58101.15
    # Santa Cruz           Santa Cruz  58006.81  34633.27
    # Shasta                   Shasta  46702.76  32882.09
    # Siskiyou               Siskiyou  21648.03  21667.03
    # Solano                   Solano  57882.93  33095.96
    # Sonoma                   Sonoma  19511.10  19782.71
    # Stanislaus           Stanislaus  68412.73  39997.43
    # Sutter                   Sutter  23041.68  22738.16
    # Tulare                   Tulare  41128.16  28933.90
    # Ventura                 Ventura 115177.43  51200.56
    # Yolo                       Yolo  14710.75  14676.49
    # > svyby(~api00, ~cname, srsrep, svymean)
    #                         cname    api00           se
    # Alameda                 Alameda 676.0909 3.522082e+01
    # Calaveras             Calaveras 790.0000 0.000000e+00
    # Contra Costa       Contra Costa 766.1111 5.435054e+01
    # Fresno                   Fresno 600.2500 5.811781e+01
    # Imperial               Imperial 622.0000 0.000000e+00
    # Kern                       Kern 573.6000 4.634744e+01
    # Kings                     Kings 469.5000 4.264356e+01
    # Lake                       Lake 804.0000 0.000000e+00
    # Lassen                   Lassen 752.0000 0.000000e+00
    # Los Angeles         Los Angeles 658.1556 2.126852e+01
    # Madera                   Madera 480.0000 3.461786e+00
    # Marin                     Marin 799.6667 3.509912e+01
    # Merced                   Merced 595.0000 0.000000e+00
    # Modoc                     Modoc 671.0000 0.000000e+00
    # Monterey               Monterey 605.0000 8.356655e+01
    # Napa                       Napa 727.0000 4.770914e+01
    # Orange                   Orange 749.3333 2.876956e+01
    # Placer                   Placer 759.0000 0.000000e+00
    # Riverside             Riverside 574.3000 2.789294e+01
    # Sacramento           Sacramento 616.0000 3.785063e+01
    # San Bernardino   San Bernardino 614.4615 2.985197e+01
    # San Diego             San Diego 684.5000 3.254291e+01
    # San Francisco     San Francisco 558.3333 4.404227e+01
    # San Joaquin         San Joaquin 608.6667 4.153241e+01
    # San Luis Obispo San Luis Obispo 739.0000 2.691382e-14
    # San Mateo             San Mateo 617.0000 7.352923e+01
    # Santa Barbara     Santa Barbara 728.6667 2.551393e+01
    # Santa Clara         Santa Clara 718.2857 5.835346e+01
    # Santa Cruz           Santa Cruz 624.3333 1.131098e+02
    # Shasta                   Shasta 754.0000 5.731963e+01
    # Siskiyou               Siskiyou 699.0000 0.000000e+00
    # Solano                   Solano 623.0000 4.541173e+01
    # Sonoma                   Sonoma 630.0000 0.000000e+00
    # Stanislaus           Stanislaus 736.3333 5.176843e+00
    # Sutter                   Sutter 744.0000 0.000000e+00
    # Tulare                   Tulare 664.0000 2.061011e+01
    # Ventura                 Ventura 743.8000 3.153839e+01
    # Yolo                       Yolo 475.0000 0.000000e+00
end

@testset "total_Stratified" begin
    apistrat_original = load_data("apistrat")

    # base functionality
    apistrat = copy(apistrat_original)
    strat = SurveyDesign(apistrat; strata = :stype, weights = :pw) |> bootweights
    tot = total(:api00, strat)
    @test tot.total[1] ≈ 4102208 atol = 10
    @test tot.SE[1] ≈ 77211.61 atol = 1e-1
    # without fpc
    # TODO: uncomment after correcting `total` function
    # @test tot.SE[1] ≈ 1690.4 atol = 1e-1

    # CategoricalArray
    # apistrat = copy(apistrat_original)
    # apistrat[!, :cname] = CategoricalArrays.categorical(apistrat.cname)
    # strat = StratifiedSample(apistrat, :stype; popsize = :fpc)
    # TODO: uncomment after adding `CategoricalArray` support
    # @test tot.SE[1] ≈ 1690.4 atol = 1e-1
    # tot = total(:cname, strat)
    # @test size(tot)[1] == apistrat.cname |> unique |> length
    # @test filter(:cname => ==("Kern"), tot).total[1] ≈ 291.97 atol = 1e-2
    # @test filter(:cname => ==("Kern"), tot).SE[1] ≈ 101.760 atol = 1e-3
    # @test filter(:cname => ==("Los Angeles"), tot).total[1] ≈ 1373.15 atol = 1e-2
    # @test filter(:cname => ==("Los Angeles"), tot).SE[1] ≈ 199.635 atol = 1e-3

    # Vector{Symbol}
    tot = total([:api00, :enroll], strat)
    ## :api00
    @test tot.total[1] ≈ 4102208 atol = 1
    @test tot.SE[1] ≈ 77211.61 atol = 1
    ## :enroll
    @test tot.total[2] ≈ 3687178 atol = 1
    @test tot.SE[2] ≈ 127021.5540 atol = 1

    # subpopulation
    # TODO: add functionality in `src/total.jl`
    # TODO: add tests
end

@testset "total_OneStageClusterSample" begin
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