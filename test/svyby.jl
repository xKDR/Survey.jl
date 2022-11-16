# TODO testing for svyby
@testset "svyby.jl" begin
    ####################################################################
    # SimpleRandomSample Test
    apisrs = load_data("apisrs")
    srs = SimpleRandomSample(apisrs, popsize = apisrs.fpc)
    ## Test svymean with svyby
    srs_svymean_svyby = svyby(:api00,:cname,srs,svymean)
    ###>>> Add tests here

    ## Test svytotal with svyby
    # srs_svytotal_svyby = svyby(:api00,:cname,srs,svytotal)
    ###>>> Add tests here

    ####################################################################
    # StratifiedSample Test
    apistrat = load_data("apistrat") # load data
    strat = StratifiedSample(apistrat, :stype ; popsize = apistrat.fpc )
    ## Test svymean with svyby
    strat_svymean_svyby = svyby(:api00,:cname,strat,svymean)
    ###>>> Add tests here

    ## Test svytotal with svyby
    # strat_svytotal_svyby = svyby(:api00,:cname,strat,svytotal)
    ###>>> Add tests here

    ####################################################################
end