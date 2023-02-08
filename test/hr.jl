@testset "hartley_rao" begin
    ### I havent been able to reproduce below in R survey, which give somewhat different SE estimates
    # base functionality SRS
    tot = total(:api00, srs)
    @test tot.SE[1] ≈ 57154.1 rtol = STAT_TOL
    # Stratified
    tot = total(:api00, dstrat)
    @test tot.SE[1] ≈ 699405 rtol = STAT_TOL
    # one stage cluster
    tot = total(:api00, dclus1)
    @test tot.SE[1] ≈ 4880240 rtol = STAT_TOL
end