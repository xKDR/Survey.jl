@testset "dimnames.jl" begin
    # Simple random sampling tests
    apisrs = load_data("apisrs")
    # make a copy to not modify the original dataset
    apisrs_copy = copy(apisrs)
    srs = SimpleRandomSample(apisrs_copy,popsize=:fpc,ignorefpc = true)
    # `dim`
    @test dim(srs)[2] == 42
    # `colnames`
    @test length(colnames(srs)) == dim(srs)[2]
    # `dimnames`
    @test length(dimnames(srs)[1]) == parse(Int, last(dimnames(srs)[1]))
    @test dimnames(srs)[2] == colnames(srs)

    # Stratified sampling tests
end
