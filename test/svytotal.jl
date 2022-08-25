@testset "svytotal.jl" begin
    # SimpleRandomSample tests
    apisrs = load_data("apisrs")

    srs_new = SimpleRandomSample(apisrs)
    srs_old = svydesign(id = :1, data = apisrs)
    tot_new = svytotal(:api00, srs_new)
    tot_old = svytotal(:api00, srs_old)
    @test tot_new.total == tot_old.total

    # StratifiedSample tests
    apistrat = load_data("apistrat")

    strat_new = StratifiedSample(apistrat, apistrat.stype)
    strat_old = svydesign(id = :1, data = apistrat, strata = :stype)
    tot_new = svytotal(:api00, strat_new)
    tot_old = svytotal(:api00, strat_old)
    @test tot_new.total == tot_old.total
end
