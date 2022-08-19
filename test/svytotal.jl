@testset "svytotal.jl" begin
    # SimpleRandomSample tests
    apisrs = load_data("apisrs")

    srs_new = SimpleRandomSample(apisrs)
    srs_old = svydesign(id = :1, data = apisrs)
    tot_new = svytotal(:api00, srs_new)
    tot_old = svytotal(:api00, srs_old)
    @test tot_new == tot_old
end
