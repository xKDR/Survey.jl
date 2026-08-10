# Quantiles follow R's oldsvyquantile (ties="discrete", linear interpolation of
# the inverse weighted CDF), so the point estimates below match R exactly.
@testset "quantile_SimpleRandomSample" begin
    @test quantile(:api00, srs, 0.5)[!, 1][1] ≈ 658.0 atol = 1e-4
    @test quantile(:api00, bsrs, 0.5)[!, 1][1] ≈ 658.0 atol = 1e-4
    @test quantile(:api00, bsrs, [0.1753, 0.25, 0.5, 0.75, 0.975])[!, 2] ≈
          [512.06, 544, 658, 752, 905] rtol = 1e-4
    @test quantile(:api00, bsrs, [0.1753, 0.25, 0.5, 0.75, 0.975])[!, 3] ≈
          [14.0207, 11.5956, 14.8882, 10.6955, 11.5857] rtol = 1e-4
    @test quantile(:enroll, bsrs, [0.1, 0.2, 0.5, 0.75, 0.95])[!, 2] ≈
          [232.0, 316.0, 453.0, 664.0, 1467.0] rtol = 1e-4
    @test quantile(:enroll, srs, [0.1, 0.2, 0.5, 0.75, 0.95])[!, 2] ≈
          [232.0, 316.0, 453.0, 664.0, 1467.0] rtol = 1e-4
end
