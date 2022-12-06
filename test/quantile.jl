@testset "quantile.jl" begin
    # SimpleRandomSample
    apisrs_original = load_data("apisrs")

	apisrs = copy(apisrs_original)
    srs_new = SimpleRandomSample(apisrs; popsize=:fpc, ignorefpc=true)
    # 0.5th percentile
    # 0.25th percentile

    # StratifiedSample
end
