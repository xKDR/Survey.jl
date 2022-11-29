# TODO testing for by
@testset "by.jl" begin
    ####################################################################
    # SimpleRandomSample Test
    apisrs = load_data("apisrs")
    srs = SimpleRandomSample(apisrs, popsize = apisrs.fpc)
    ## Test mean with by
    srs_mean_by = by(:api00,:cname,srs,mean)
    ###>>> Add tests here

    ## Test total with by
    # srs_total_by = by(:api00,:cname,srs,total)
    ###>>> Add tests here

    ####################################################################
    # StratifiedSample Test
    apistrat = load_data("apistrat") # load data
    strat = StratifiedSample(apistrat, :stype ; popsize = apistrat.fpc )
    ## Test mean with by
    strat_mean_by = by(:api00,:cname,strat,mean)
    ###>>> Add tests here

    ## Test total with by
    # strat_total_by = by(:api00,:cname,strat,total)
    ###>>> Add tests here

    ####################################################################
end