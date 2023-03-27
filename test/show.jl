@testset "No strata, no clusters" begin
    io = IOBuffer()
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

    refstrb = """
    ReplicateDesign:
    data: 200×4045 DataFrame
    strata: none
    cluster: none
    popsize: [6194.0, 6194.0, 6194.0  …  6194.0]
    sampsize: [200, 200, 200  …  200]
    weights: [30.97, 30.97, 30.97  …  30.97]
    allprobs: [0.0323, 0.0323, 0.0323  …  0.0323]
    type: bootstrap
    replicates: 4000"""

    show(io, MIME("text/plain"), bsrs)
    strb = String(take!(io))
    @test strb == refstrb
end

@testset "With strata, no clusters" begin
    io = IOBuffer()

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

    show(io, MIME("text/plain"), dstrat)
    str = String(take!(io))
    @test str == refstr

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
    type: bootstrap
    replicates: 4000"""

    show(io, MIME("text/plain"), bstrat)
    strb = String(take!(io))
    @test strb == refstrb
end

@testset "No strata, with clusters" begin
    io = IOBuffer()

    refstr = """
    SurveyDesign:
    data: 183×44 DataFrame
    strata: none
    cluster: dnum
        [637, 637, 637  …  448]
    popsize: [757.0, 757.0, 757.0  …  757.0]
    sampsize: [15, 15, 15  …  15]
    weights: [50.4667, 50.4667, 50.4667  …  50.4667]
    allprobs: [0.0198, 0.0198, 0.0198  …  0.0198]"""

    show(io, MIME("text/plain"), dclus1)
    str = String(take!(io))
    @test str == refstr

    refstrb = """
    ReplicateDesign:
    data: 183×4044 DataFrame
    strata: none
    cluster: dnum
        [61, 61, 61  …  815]
    popsize: [757.0, 757.0, 757.0  …  757.0]
    sampsize: [15, 15, 15  …  15]
    weights: [50.4667, 50.4667, 50.4667  …  50.4667]
    allprobs: [0.0198, 0.0198, 0.0198  …  0.0198]
    type: bootstrap
    replicates: 4000"""

    show(io, MIME("text/plain"), dclus1_boot)
    strb = String(take!(io))
    @test strb == refstrb
end

@testset "makeshort" begin
    @test Survey.makeshort(pi / 2) == "1.5708"
    @test Survey.makeshort(23) == "23"
    @test Survey.makeshort(ones(100)) == "[1.0, 1.0, 1.0  …  1.0]"
    @test Survey.makeshort(ones(3)) == "[1.0, 1.0, 1.0]"
    @test Survey.makeshort(ones(2)) == "[1.0, 1.0]"
    @test Survey.makeshort(1:8) == "[1, 2, 3  …  8]"
end
