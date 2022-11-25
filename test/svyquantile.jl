@testset "svyquantile.jl" begin
    # SimpleRandomSample
    apisrs = load_data("apisrs")

    srs_new = SimpleRandomSample(apisrs,popsize=:fpc,ignorefpc = true)
    srs_old = svydesign(id = :1, data = apisrs)
    # 0.5th percentile
    q_05_new = svyquantile(:api00, srs_new, 0.5)
    q_05_old = svyquantile(:api00, srs_old, 0.5)
    @test q_05_new == q_05_old
    # 0.25th percentile
    q_025_new = svyquantile(:api00, srs_new, 0.25)
    q_025_old = svyquantile(:api00, srs_old, 0.25)
    @test q_025_new == q_025_old

    # StratifiedSample
end
