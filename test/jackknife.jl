@testset "jackknife" begin
    dstrat_jk = jackknifeweights(dstrat)
    mean(:api00,dstrat_jk)
    mean(:api99,dstrat_jk)
    # dnhanes_jk = jackknifeweights(dnhanes)
    # dclus1_jk = jackknifeweights(dclus1)
end