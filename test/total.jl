@testset "total SRS" begin

    # base functionality
    tot = total(:api00, srs)
    @test tot.total[1] ≈ 4066888 rtol = STAT_TOL

    tot = total(:api00, bsrs)
    @test tot.total[1] ≈ 4066888 rtol = STAT_TOL
    @test tot.SE[1] ≈ 58526 rtol = SE_TOL
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
    ## :api00
    @test tot.total[1] ≈ 4066888 rtol = STAT_TOL
    ## :enroll
    @test tot.total[2] ≈ 3621074 rtol = STAT_TOL
    tot = total([:api00, :enroll], bsrs)
    ## :api00
    @test tot.total[1] ≈ 4066888 rtol = STAT_TOL
    @test tot.SE[1] ≈ 57502 rtol = SE_TOL
    ## :enroll
    @test tot.total[2] ≈ 3621074 rtol = STAT_TOL
    @test tot.SE[2] ≈ 176793 rtol = SE_TOL
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
    @test filter(:cname => ==("Monterey"), tot).total[1] ≈ 74947.40 rtol = STAT_TOL

    tot = total(:api00, :cname, bsrs)
    @test size(tot)[1] == apisrs.cname |> unique |> length
    @test filter(:cname => ==("Los Angeles"), tot).total[1] ≈ 917238.49 rtol = STAT_TOL
    @test filter(:cname => ==("Los Angeles"), tot).SE[1] ≈ 122193.02 rtol = SE_TOL
    @test filter(:cname => ==("Monterey"), tot).total[1] ≈ 74947.40 rtol = STAT_TOL
    @test filter(:cname => ==("Monterey"), tot).SE[1] ≈ 38862.71 rtol = SE_TOL
    # equivalent R code (results cause clutter):
    # > svyby(~api00, ~cname, srsrep, svytotal)
    # > svyby(~api00, ~cname, srsrep, svymean)
end

@testset "total Stratified" begin
    # base functionality
    tot = total(:api00, dstrat)
    @test tot.total[1] ≈ 4102208 rtol = STAT_TOL

    tot = total(:api00, bstrat)
    @test tot.total[1] ≈ 4102208 rtol = STAT_TOL
    @test tot.SE[1] ≈ 60746 rtol = SE_TOL
    # equivalent R code and results:
    # > dstrat <- svydesign(data=apistrat, id=~1, weights=~pw, strata=~stype)
    # > stratrep <- as.svrepdesign(dstrat, type="bootstrap", replicates=4000)
    # > svytotal(~api00, stratrep)
    #     total    SE
    # api00 4102208 60746
    # > svymean(~api00, stratrep)
    #     mean     SE
    # api00 662.29 9.8072

    # Vector{Symbol}
    tot = total([:api00, :enroll], dstrat)
    @test tot.total[1] ≈ 4102208 rtol = STAT_TOL ## :api00
    @test tot.total[2] ≈ 3687178 rtol = STAT_TOL ## :enroll

    tot = total([:api00, :enroll], bstrat)
    ## :api00
    @test tot.total[1] ≈ 4102208 rtol = STAT_TOL
    @test tot.SE[1] ≈ 60746 rtol = SE_TOL
    ## :enroll
    @test tot.total[2] ≈ 3687178 rtol = STAT_TOL
    @test tot.SE[2] ≈ 117322 rtol = SE_TOL
    # equivalent R code and results:
    # > svytotal(~api00+~enroll, stratrep)
    # > svymean(~api00+~enroll, stratrep)
    #         mean      SE
    # api00  662.29  9.8072
    # enroll 595.28 18.9412

    # subpopulation
    tot = total(:api00, :cname, dstrat)
    @test size(tot)[1] == apistrat.cname |> unique |> length
    @test filter(:cname => ==("Los Angeles"), tot).total[1] ≈ 869905.98 rtol = STAT_TOL
    @test filter(:cname => ==("Monterey"), tot).total[1] ≈ 72103.09 rtol = STAT_TOL

    tot = total(:api00, :cname, bstrat)
    @test size(tot)[1] == apistrat.cname |> unique |> length
    @test filter(:cname => ==("Los Angeles"), tot).total[1] ≈ 869905.98 rtol = STAT_TOL
    @test filter(:cname => ==("Los Angeles"), tot).SE[1] ≈ 134195.81 rtol = SE_TOL
    @test filter(:cname => ==("Monterey"), tot).total[1] ≈ 72103.09 rtol = STAT_TOL
    @test filter(:cname => ==("Monterey"), tot).SE[1] ≈ 45532.88 rtol = SE_TOL
    # equivalent R code (results cause clutter):
    # > svyby(~api00, ~cname, stratrep, svytotal)
    # > svyby(~api00, ~cname, stratrep, svymean)
end

@testset "total Cluster" begin
    tot = total(:api00, dclus1)
    @test tot.total[1] ≈ 5949162 rtol = STAT_TOL

    tot = total(:api00, dclus1_boot)
    @test tot.total[1] ≈ 5949162 rtol = STAT_TOL
    @test tot.SE[1] ≈ 1352205 rtol = SE_TOL
    # equivalent R code and results:
    # > apiclus1$pw = 757/15
    # > clus1 <- svydesign(data=apiclus1, id=~dnum, weights=~pw)
    # > clus1rep <- as.svrepdesign(clus1, type="bootstrap", replicates=4000)
    # > svytotal(~api00, clus1rep)
    #         total     SE
    # api00 3989986 900323
    # > svymean(~api00, clus1rep)
    #         mean     SE
    # api00 644.17 23.534

    # Vector{Symbol}
    tot = total([:api00, :enroll], dclus1)
    ## :api00
    @test tot.total[1] ≈ 5949162 rtol = STAT_TOL
    ## :enroll
    @test tot.total[2] ≈ 5076846 rtol = STAT_TOL

    tot = total([:api00, :enroll], dclus1_boot)
    ## :api00
    @test tot.total[1] ≈ 5949162 rtol = STAT_TOL
    @test tot.SE[1] ≈ 1352205 rtol = SE_TOL
    ## :enroll
    @test tot.total[2] ≈ 5076846 rtol = STAT_TOL
    @test tot.SE[2] ≈ 1405590 rtol = SE_TOL
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
    tot = total(:api00, :cname, dclus1)
    @test size(tot)[1] == apiclus1.cname |> unique |> length
    @test filter(:cname => ==("Los Angeles"), tot).total[1] ≈ 489980.87 rtol = STAT_TOL
    @test filter(:cname => ==("San Diego"), tot).total[1] ≈ 1830375.53 rtol = STAT_TOL

    tot = total(:api00, :cname, dclus1_boot)
    @test size(tot)[1] == apiclus1.cname |> unique |> length
    @test filter(:cname => ==("Los Angeles"), tot).total[1] ≈ 489980.87 rtol = STAT_TOL
    @test filter(:cname => ==("Los Angeles"), tot).SE[1] ≈ 430469.28 rtol = SE_TOL
    @test filter(:cname => ==("San Diego"), tot).total[1] ≈ 1830375.53 rtol = STAT_TOL
    @test filter(:cname => ==("San Diego"), tot).SE[1] ≈ 1298696.64 rtol = SE_TOL
    # equivalent R code (results cause clutter):
    # > svyby(~api00, ~cname, clus1rep, svytotal)
    # > svyby(~api00, ~cname, clus1rep, svymean)
    
    # Test multiple domains passed at once
    tot = total(:api00, [:stype,:cname], dclus1_boot)
    @test filter(row -> row[:stype_cname] == "E-Los Angeles", tot).SE[1] ≈ 343365 rtol = STAT_TOL
    @test filter(row -> row[:stype_cname] == "H-Merced", tot).SE[1] ≈ 27090.33 rtol = STAT_TOL

    #### Why doesnt this syntax produce domain estimates??
    # Test that column specifiers from DataFrames make it through this pipeline
    # These tests replicate what you see above...just with a different syntax.
    # tot = total(:api00, Survey.DataFrames.Cols(==(:cname)), dclus1_boot)
    ######## Above Survey.DataFrames.Cols(==(:cname)) syntax doesnt give domain estimates
    # @test size(tot)[1] == apiclus1.cname |> unique |> length
    # @test filter(:cname => ==("Los Angeles"), tot).total[1] ≈ 489980.87 rtol = STAT_TOL
    # @test filter(:cname => ==("Los Angeles"), tot).SE[1] ≈ 430469.28 rtol = SE_TOL
    # @test filter(:cname => ==("San Diego"), tot).total[1] ≈ 1830375.53 rtol = STAT_TOL
    # @test filter(:cname => ==("San Diego"), tot).SE[1] ≈ 1298696.64 rtol = SE_TOL
end

#### R code for vector{Symbol} domain estimation
# > data(api)
# > apiclus1$pw = rep(757/15,nrow(apiclus1))
# > ### 9.04.23
# > dclus1<-svydesign(id=~dnum, weights=~pw, data=apiclus1);
# > rclus1<-as.svrepdesign(dclus1, type="subbootstrap", compress=FALSE, replicates = 4000)
# > svyby(~api00, ~stype+cname, rclus1, svytotal)
#               stype       cname      api00         se
# E.Alameda         E     Alameda  273428.40  275423.33
# H.Alameda         H     Alameda   30683.73   30907.60
# M.Alameda         M     Alameda   67272.07   67762.88
# E.Fresno          E      Fresno   48599.40   47484.67
# H.Fresno          H      Fresno   22356.73   21843.93
# M.Fresno          M      Fresno   24324.93   23766.99
# E.Kern            E        Kern   24930.53   24847.76
# M.Kern            M        Kern   20741.80   20672.93
# E.Los Angeles     E Los Angeles  395154.00  341692.92
# M.Los Angeles     M Los Angeles   94826.87   95416.42
# E.Mendocino       E   Mendocino   58844.13   57711.15
# H.Mendocino       H   Mendocino   35124.80   34448.51
# M.Mendocino       M   Mendocino   31844.47   31231.33
# E.Merced          E      Merced   50517.13   51424.65
# H.Merced          H      Merced   26696.87   27176.47
# M.Merced          M      Merced   27605.27   28101.18
# E.Orange          E      Orange  463536.33  465047.76
# M.Orange          M      Orange  110219.20  110578.59
# E.Plumas          E      Plumas  144284.20  146672.86
# H.Plumas          H      Plumas  143729.07  146108.54
# M.Plumas          M      Plumas   34266.87   34834.16
# E.San Diego       E   San Diego 1670497.13 1233144.04
# H.San Diego       H   San Diego   63386.13   63693.54
# M.San Diego       M   San Diego   96492.27   96960.22
# E.San Joaquin     E San Joaquin  848243.73  848605.33
# H.San Joaquin     H San Joaquin   79585.93   79619.86
# M.San Joaquin     M San Joaquin  101387.53  101430.75
# E.Santa Clara     E Santa Clara  737418.93  484164.71
# H.Santa Clara     H Santa Clara   35478.07   35311.28
# M.Santa Clara     M Santa Clara  187685.53  131278.63