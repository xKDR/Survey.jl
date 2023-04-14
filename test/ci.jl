@testset "ci.jl" begin
    #### Each of the 3 options with default keyword arguments
    # 95% CI - normal
    @test mean(:api00, dclus1_boot, "normal").ci_lower[1] ≈ 598.28529 atol = 1e-4
    # 95% CI, with dof=Infinity - t
    @test mean(:api00, dclus1_boot, "t").ci_upper[1] ≈ 690.3606 atol = 1e-4
    # margin of 2 SE
    @test mean(:api00, dclus1_boot, "margin").ci_upper[1] ≈ 690.99077 atol = 1e-4

    #### Test "normal" keyword options 
    # 90% CI
    @test mean(:api00, dclus1_boot, "normal", alpha = 0.1).ci_upper[1] ≈ 682.67655 atol = 1e-4
    # 85% CI
    @test mean(:api00, dclus1_boot, "normal", alpha = 0.15).ci_lower[1] ≈ 610.469 atol = 1e-4

    #### Test "t" keyword options
    #### For illustration purposes, dclus1_boot is actually a 'large' sample
    # 90% CI
    @test mean(:api00, dclus1_boot, "t", dof = 30).ci_upper[1] ≈ 691.9804 atol = 1e-4
    # 85% CI
    @test mean(:api00, dclus1_boot, "t", alpha = 0.1, dof = 50).ci_lower[1] ≈ 604.9353 atol = 1e-4

    #### Test "t" keyword options
    # 3 - sigma
    @test mean(:api00, dclus1_boot, "margin", margin=3.0).ci_upper[1] ≈ 714.40146 atol = 1e-4 
    # Six-sigma
    @test mean(:api00, dclus1_boot, "margin", margin=6.0).ci_lower[1] ≈ 503.70526 atol = 1e-4

    #### Test Vector of Symbols
    @test mean([:api00, :enroll], dclus1_boot, "normal").ci_lower[2] ≈ 459.98174 atol = 1e-4
    @test mean([:api00, :enroll], dclus1_boot, "normal").ci_upper[2] ≈ 639.44995 atol = 1e-4

    #### Test domain estimation
    mn = mean(:api00, :cname, dclus1_boot, "normal")
    @test filter(:cname => ==("Los Angeles"), mn).ci_lower[1] ≈ 553.92680 atol = 1e-4
    @test filter(:cname => ==("Santa Clara"), mn).ci_upper[1] ≈ 846.17990 atol = 1e-4
end