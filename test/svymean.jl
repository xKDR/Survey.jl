@testset "svymean.jl" begin
    # SimpleRandomSample tests
    apisrs = load_data("apisrs")

    srs_new = SimpleRandomSample(apisrs)
    srs_old = svydesign(id = :1, data = apisrs)
    mean_new = svymean(:api00, srs_new)
    mean_old = svymean(:api00, srs_old)
    @test mean_new == mean_old
end
