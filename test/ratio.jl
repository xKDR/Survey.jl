@testset "ratio.jl" begin
    # on :api00
    @test ratio(:api00, :enroll, srs).ratio[1] ≈ 1.1231 atol = 1e-4
    @test ratio(:api00, :enroll, dclus1).ratio[1] ≈ 1.17182 atol = 1e-4
    @test ratio(:api00, :enroll, dclus1_boot).SE[1] ≈ 0.1275446 atol = 1e-1
    @test ratio(:api00, :enroll, dclus1_boot).ratio[1] ≈ 1.17182 atol = 1e-4
    @test ratio(:api00, :enroll, bstrat).ratio[1] ≈ 1.11256 atol = 1e-4
    @test ratio(:api00, :enroll, bstrat).SE[1] ≈ 0.04185 atol = 1e-1
    @test ratio(:api00, :enroll, bstrat).ratio[1] ≈ 1.11256 atol = 1e-4
    # on :api99
    @test ratio(:api99, :enroll, bsrs).ratio[1] ≈ 1.06854 atol = 1e-4
    @test ratio(:api99, :enroll, dstrat).ratio[1] ≈ 1.0573 atol = 1e-4
    @test ratio(:api99, :enroll, bstrat).ratio[1] ≈ 1.0573 atol = 1e-4
end
