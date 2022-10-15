@testset "dimnames.jl" begin
    # Simple random sampling tests
    apisrs = load_data("apisrs")
    # make a copy to not modify the original dataset
    apisrs_copy = copy(apisrs)
    srs_new = SimpleRandomSample(apisrs_copy,ignorefpc = true)
    # make a new copy to use for the old design
    apisrs_copy = copy(apisrs)
    srs_old = svydesign(id = :1, data = apisrs)
    # `dim`
    @test dim(srs_new)[1] == dim(srs_old)[1]
    @test dim(srs_new)[2] == 42
    @test dim(srs_old)[2] == 45
    # `colnames`
    @test length(colnames(srs_new)) == dim(srs_new)[2]
    @test length(colnames(srs_old)) == dim(srs_old)[2]
    # `dimnames`
    @test length(dimnames(srs_new)[1]) == parse(Int, last(dimnames(srs_new)[1]))
    @test dimnames(srs_new)[2] == colnames(srs_new)
    @test length(dimnames(srs_old)[1]) == parse(Int, last(dimnames(srs_old)[1]))
    @test dimnames(srs_old)[2] == colnames(srs_old)

    # Stratified sampling tests
end
