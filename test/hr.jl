@testset "hartley_rao" begin
    # base functionality
    tot = total(:api00, srs)
    @test tot.total[2] ≈ 4066888 rtol = STAT_TOL
    
    tot = total(:api00, dstrat)
    @test tot.total[2] ≈ 4066888 rtol = STAT_TOL

    tot = total(:api00, dclus1)
    @test tot.total[2] ≈ 4066888 rtol = STAT_TOL
end