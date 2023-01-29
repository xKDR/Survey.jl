@testset "No strata, no clusters" begin
    io = IOBuffer()

    apisrs = load_data("apisrs")
    srs = SurveyDesign(apisrs; weights=:pw)
    refstr = """
    SurveyDesign:
    data: 200×45 DataFrame
    strata: none
    cluster: none
    popsize: [6194.0, 6194.0, 6194.0  …  6194.0]
    sampsize: [200, 200, 200  …  200]
    weights: [30.97, 30.97, 30.97  …  30.97]
    allprobs: [0.0323, 0.0323, 0.0323  …  0.0323]"""

    show(io, MIME("text/plain"), srs)
    str = String(take!(io))
    @test str == refstr

    bsrs = srs |> bootweights
    refstrb = """
    ReplicateDesign:
    data: 200×4045 DataFrame
    strata: none
    cluster: none
    popsize: [6194.0, 6194.0, 6194.0  …  6194.0]
    sampsize: [200, 200, 200  …  200]
    weights: [30.97, 30.97, 30.97  …  30.97]
    allprobs: [0.0323, 0.0323, 0.0323  …  0.0323]
    replicates: 4000"""

    show(io, MIME("text/plain"), bsrs)
    strb = String(take!(io))
    @test strb == refstrb
end

@testset "With strata, no clusters" begin
    io = IOBuffer()

    apistrat = load_data("apistrat")
    strat = SurveyDesign(apistrat; strata=:stype, weights=:pw)
    refstr = """
    SurveyDesign:
    data: 200×44 DataFrame
    strata: stype
        [E, E, E  …  H]
    cluster: none
    popsize: [4420.9999, 4420.9999, 4420.9999  …  755.0]
    sampsize: [100, 100, 100  …  50]
    weights: [44.21, 44.21, 44.21  …  15.1]
    allprobs: [0.0226, 0.0226, 0.0226  …  0.0662]"""

    show(io, MIME("text/plain"), strat)
    str = String(take!(io))
    @test str == refstr

    stratb = strat |> bootweights
    refstrb = """
    ReplicateDesign:
    data: 200×4044 DataFrame
    strata: stype
        [E, E, E  …  H]
    cluster: none
    popsize: [4420.9999, 4420.9999, 4420.9999  …  755.0]
    sampsize: [100, 100, 100  …  50]
    weights: [44.21, 44.21, 44.21  …  15.1]
    allprobs: [0.0226, 0.0226, 0.0226  …  0.0662]
    replicates: 4000"""

    show(io, MIME("text/plain"), stratb)
    strb = String(take!(io))
    @test strb == refstrb
end

@testset "No strata, with clusters" begin
    io = IOBuffer()

    apiclus1 = load_data("apiclus1")
    clus_one_stage = SurveyDesign(apiclus1; clusters = :dnum, weights = :pw)
    refstr = """
    SurveyDesign:
    data: 183×44 DataFrame
    strata: none
    cluster: dnum
        [637, 637, 637  …  448]
    popsize: [507.7049, 507.7049, 507.7049  …  507.7049]
    sampsize: [15, 15, 15  …  15]
    weights: [33.847, 33.847, 33.847  …  33.847]
    allprobs: [0.0295, 0.0295, 0.0295  …  0.0295]"""

    show(io, MIME("text/plain"), clus_one_stage)
    str = String(take!(io))
    @test str == refstr

    clus_one_stageb = clus_one_stage |> bootweights
    refstrb = """
    ReplicateDesign:
    data: 183×4044 DataFrame
    strata: none
    cluster: dnum
        [61, 61, 61  …  815]
    popsize: [507.7049, 507.7049, 507.7049  …  507.7049]
    sampsize: [15, 15, 15  …  15]
    weights: [33.847, 33.847, 33.847  …  33.847]
    allprobs: [0.0295, 0.0295, 0.0295  …  0.0295]
    replicates: 4000"""

    show(io, MIME("text/plain"), clus_one_stageb)
    strb = String(take!(io))
    @test strb == refstrb
end
