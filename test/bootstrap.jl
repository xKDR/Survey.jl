using Random, StatsBase
apiclus1 = load_data("apiclus1")
dclus1 = OneStageClusterSample(apiclus1, :dnum, :fpc); 
rng = MersenneTwister(111); 
func = wsum; 
est = Survey.bootstrap(:api00, dclus1, func; replicates=1000, rng)
@testset "bootstrap.jl" begin
    @test est.SE[1] ≈ 1.365925776009e6
    @test est.statistic[1] ≈ 5.9491620666e6
end