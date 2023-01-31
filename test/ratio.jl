@testset "ratio.jl" begin
    @test ratio(:api00, :enroll, dclus1).ratio[1] ≈ 1.17182 atol = 1e-4
    @test ratio(:api00, :enroll, dclus1_boot).SE[1] ≈ 0.1275446 atol = 1e-1
    @test ratio(:api00, :enroll, dclus1_boot).ratio[1] ≈ 1.17182 atol = 1e-4
end