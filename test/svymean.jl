@testset "svymean.jl" begin
    # SimpleRandomSample
    using DataFrames
    apisrs = load_data("apisrs")
    apisrs.apidiff = apisrs.api00 - apisrs.api99
    apisrs.apipct = apisrs.apidiff ./ apisrs.api99
    srs = SimpleRandomSample(apisrs, popsize = apisrs.fpc)
    # with fpc
    
    @test svymean(:api00, srs).mean[1] == 656.585
    @test svymean(:api00, srs).sem[1] ≈ 9.249722039282807
    @test svymean(:enroll, srs).mean[1] ≈ 584.61
    @test svymean(:enroll, srs).sem[1] ≈ 27.36836524766856
    # without fpc

    srs = SimpleRandomSample(apisrs, ignorefpc = true)
    @test svymean(:api00, srs).mean[1] == 656.585
    @test svymean(:api00, srs).sem[1] ≈ 9.402772170880636

    @test svymean(:enroll, srs).mean[1] ≈ 584.61
    @test svymean(:enroll, srs).sem[1] ≈ 27.821214737089324
    @test svymean([:apidiff, :apipct], srs).mean[1][1] ≈ 31.900000 
    @test svymean([:api99,:api00],srs).mean ≈  [624.685,656.585]

    srs_weights = SimpleRandomSample(apisrs, ignorefpc = false, weights = :fpc)
    @test svymean(:enroll, srs_weights).mean[1] ≈ 584.61

    srs_w_p = srs_weights = SimpleRandomSample(apisrs, ignorefpc = false, weights = :fpc, probs = fill(0.3, size(apisrs_original, 1)))
    @test svymean(:enroll, srs_weights).mean[1] ≈ 584.61 
end
