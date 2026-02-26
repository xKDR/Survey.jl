@testset "ratio.jl" begin
    # on :api00
    @test ratio([:api00, :enroll], srs).ratio[1] ≈ 1.1231 atol = 1e-4
    @test ratio([:api00, :enroll], dclus1).ratio[1] ≈ 1.17182 atol = 1e-4
    @test ratio([:api00, :enroll], dclus1_boot).SE[1] ≈ 0.1275446 atol = 1e-1
    @test ratio([:api00, :enroll], dclus1_boot).estimator[1] ≈ 1.17182 atol = 1e-4
    @test ratio([:api00, :enroll], bstrat).estimator[1] ≈ 1.11256 atol = 1e-4
    @test ratio([:api00, :enroll], bstrat).SE[1] ≈ 0.04185 atol = 1e-1
    @test ratio([:api00, :enroll], bstrat).estimator[1] ≈ 1.11256 atol = 1e-4
    # on :api99
    @test ratio([:api99, :enroll], bsrs).estimator[1] ≈ 1.06854 atol = 1e-4
    @test ratio([:api99, :enroll], dstrat).ratio[1] ≈ 1.0573 atol = 1e-4
    @test ratio([:api99, :enroll], bstrat).estimator[1] ≈ 1.0573 atol = 1e-4
end
@testset "Ratio Calculation with Predefined Survey Designs and Domains" begin
    using DataFrames, Test, Survey, StatsBase
    @test ratio([:api00, :enroll], :cname, dclus1).ratio[1] ≈ 1.21016 atol = 1e-4
    @test ratio([:api00, :enroll], :cname, dclus1).ratio[2] ≈ 1.31476 atol = 1e-4 
    @test ratio([:api00, :enroll], :cname, dclus1_boot).SE[1] ≈ 0.2270863 atol = 1e-1
    @test ratio([:api00, :enroll], :cname, dclus1_boot).estimator[1] ≈ 1.31942 atol = 1e-4
    @test ratio([:api00, :enroll], :cname, bstrat).estimator[1] ≈ 0.95941 atol = 1e-4
    @test ratio([:api00, :enroll], :cname, bstrat).SE[1] ≈ 0.1050788 atol = 1e-1
    @test ratio([:api00, :enroll], :cname, bstrat).estimator[1] ≈ 0.95941 atol = 1e-4
    @test ratio([:api99, :enroll], :cname, dstrat).ratio[1] ≈ 0.90798 atol = 1e-4
    @test ratio([:api99, :enroll], :cname, bstrat).estimator[1] ≈ 0.90798 atol = 1e-4
    @test ratio([:api99, :enroll], :cname, bsrs).estimator[1] ≈ 0.87331 atol = 1e-4
end
