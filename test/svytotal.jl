@testset "svytotal.jl" begin
    # SimpleRandomSample
    apisrs = load_data("apisrs")

    # without fpc
    srs = SimpleRandomSample(apisrs, ignorefpc = true)
    tot = svytotal(:api00, srs)
    @test tot.total[1] == 131317.0
    @test tot.se_total[1] ≈ 1880.5544341761279

    # with fpc
    srs = SimpleRandomSample(apisrs, popsize = apisrs.fpc)
    tot = svytotal(:api00, srs)
    @test tot.total[1] ≈ 4.06688749e6
    @test tot.se_total[1] ≈ 57292.7783113177

    # StratifiedSample
end
