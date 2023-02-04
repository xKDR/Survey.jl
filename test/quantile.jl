@testset "quantile_SimpleRandomSample" begin
    @test quantile(:api00, srs, 0.5)[!, 1][1] ≈ 659.0 atol = 1e-4
    @test quantile(:api00, bsrs, 0.5)[!, 1][1] ≈ 659.0 atol = 1e-4
    @test quantile(:api00, bsrs, [0.1753, 0.25, 0.5, 0.75, 0.975])[!, 2] ≈
          [512.8847, 544, 659, 752.5, 905] rtol = 1e-4
    @test quantile(:api00, bsrs, [0.1753, 0.25, 0.5, 0.75, 0.975])[!, 3] ≈
          [14.6761, 12.7793, 14.9763, 10.7707, 11.2990] rtol = 1e-4
    @test quantile(:enroll, bsrs, [0.1, 0.2, 0.5, 0.75, 0.95])[!, 2] ≈
          [245.5, 317.6, 453.0, 668.5, 1473.1] rtol = 1e-4
    @test quantile(:enroll, srs, [0.1, 0.2, 0.5, 0.75, 0.95])[!, 2] ≈
          [245.5, 317.6, 453.0, 668.5, 1473.1] rtol = 1e-4
end
