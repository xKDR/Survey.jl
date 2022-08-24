@testset "svyby.jl" begin
    # SimpleRandomSample tests
    apisrs = load_data("apisrs")

    srs = SimpleRandomSample(apisrs)
    # `svyby` with `svytotal`
    srs_by_cname1 = svyby(:api00, :cname, srs, svytotal)
    @test srs_by_cname1.cname == unique(apisrs.cname)
    @test srs_by_cname1[srs_by_cname1.cname .== "Los Angeles", :].total ==  [29617.0]
    # `svyby` with `svymean`
    srs_by_cname2 = svyby(:api00, :cname, srs, svymean)
    @test srs_by_cname2[srs_by_cname2.cname .== "Los Angeles", :].mean[1] ≈ 658.1555555555556

    srs_freq = SimpleRandomSample(apisrs; weights = repeat([0.3], size(apisrs, 1)))
    # `svyby` with `svytotal`
    srs_by_cname_freq1 = svyby(:api00, :cname, srs_freq, svytotal)
    @test srs_by_cname_freq1.total ≈ srs_by_cname1.total .* 0.3
    # `svyby` with `svymean`
    srs_by_cname_freq2  = svyby(:api00, :cname, srs_freq, svymean)
    @test srs_by_cname_freq2.mean ≈ srs_by_cname2.mean

    srs_prob = SimpleRandomSample(apisrs; probs = repeat([0.3], size(apisrs, 1)))
    # `svyby` with `svyquantile`
    srs_by_cname_prob1 = svyby(:api00, :cname, srs_prob, svyquantile, 0.5)
    @test srs_by_cname_prob1[srs_by_cname_prob1.cname .== "Los Angeles", :][!, 2][1] ≈ 644.0
    srs_by_cname_prob2 = svyby(:api00, :cname, srs_prob, svyquantile, 0.25)
    @test srs_by_cname_prob2[srs_by_cname_prob2.cname .== "Los Angeles", :][!, 2][1] ≈ 540.0


    # StratifiedSample tests
    apistrat = load_data("apistrat")
    strat = StratifiedSample(apistrat, apistrat.stype)
    # `svyby` with `svytotal`
    strat_by_cname1 = svyby(:api00, :cname, strat, svytotal)
    @test strat_by_cname1.cname == unique(apistrat.cname)
    @test strat_by_cname1[strat_by_cname1.cname .== "Los Angeles", :].total ==  [25283.0]
    # `svyby` with `svymean`
    strat_by_cname2 = svyby(:api00, :cname, strat, svymean)
    @test strat_by_cname2[strat_by_cname2.cname .== "Los Angeles", :].mean[1] ≈ 616.6585365853658

    apistrat = load_data("apistrat")
    strat_freq = StratifiedSample(apistrat, apistrat.stype; weights = repeat([0.3], size(apistrat, 1)))
    # `svyby` with `svytotal`
    strat_by_cname_freq1 = svyby(:api00, :cname, strat_freq, svytotal)
    @test strat_by_cname_freq1.total ≈ strat_by_cname1.total .* 0.3
    # `svyby` with `svymean`
    strat_by_cname_freq2  = svyby(:api00, :cname, strat_freq, svymean)
    @test strat_by_cname_freq2.mean ≈ strat_by_cname2.mean

    apistrat = load_data("apistrat")
    strat_prob = StratifiedSample(apistrat, apistrat.stype; probs = repeat([0.3], size(apistrat, 1)))
    # `svyby` with `svyquantile`
    strat_by_cname_prob1 = svyby(:api00, :cname, strat_prob, svyquantile, 0.5)
    @test strat_by_cname_prob1[strat_by_cname_prob1.cname .== "Los Angeles", :][!, 2][1] ≈ 588.0
    strat_by_cname_prob2 = svyby(:api00, :cname, strat_prob, svyquantile, 0.25)
    @test strat_by_cname_prob2[strat_by_cname_prob2.cname .== "Los Angeles", :][!, 2][1] ≈ 510.0
end
