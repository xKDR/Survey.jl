@testset "svytotal.jl" begin
    # SimpleRandomSample
    apisrs = load_data("apisrs")
    # with fpc
    srs = SimpleRandomSample(apisrs, popsize = apisrs.fpc)
    tot = svytotal(:api00, srs)
    @test tot.total[1] ≈ 4.06688749e6
    @test tot.se_total[1] ≈ 57292.7783113177
    # TODO: ignorefpc tests dont actaully work??
    # # without fpc
    # srs = SimpleRandomSample(apisrs, popsize = :fpc, ignorefpc = true)
    # tot = svytotal(:api00, srs)
    # @test tot.total[1] == 131317.0
    # @test tot.se_total[1] ≈ 1880.5544341761279

    # StratifiedSample
end
