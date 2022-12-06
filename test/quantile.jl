@testset "quantile_SimpleRandomSample" begin
    ##### SimpleRandomSample tests
    # Load API datasets
    apisrs_original = load_data("apisrs")
    apisrs_original[!, :derived_probs] = 1 ./ apisrs_original.pw
    apisrs_original[!, :derived_sampsize] = fill(200.0, size(apisrs_original, 1))
    ##############################
    ### weights or probs as Symbol
    apisrs = copy(apisrs_original)
    srs_design = SimpleRandomSample(apisrs,popsize=:fpc)
    


    # srs_old = design(id = :1, data = apisrs)
    # 0.5th percentile
    q_05_new = quantile(:api00, srs_new, 0.5)
    # q_05_old = quantile(:api00, srs_old, 0.5)
    @test q_05_new == q_05_old
    # 0.25th percentile
    q_025_new = quantile(:api00, srs_new, 0.25)
    # q_025_old = quantile(:api00, srs_old, 0.25)
    # @test q_025_new == q_025_old

    # StratifiedSample
end
