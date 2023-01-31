@testset "quantile_SimpleRandomSample" begin
    @test quantile(:api00, srs, 0.5)[!,1][1] ≈ 659.0 atol=1e-4
    @test quantile(:api00, srs_boot, 0.5)[!,1][1] ≈ 659.0 atol=1e-4
    @test quantile(:api00, srs_boot, [0.1753,0.25,0.5,0.75,0.975])[!,2] ≈ [512.8847,544,659,752.5,905] atol = 1e-4
    @test quantile(:enroll,srs_boot, [0.1,0.2,0.5,0.75,0.95])[!,2] ≈ [245.5,317.6,453.0,668.5,1473.1] atol = 1e-4 
end