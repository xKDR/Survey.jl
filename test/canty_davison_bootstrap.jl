using Survey
using Test
using Random
using DataFrames

# Load test data
apisrs = load_data("apisrs")
apiclus1 = load_data("apiclus1")
apistrat = load_data("apistrat")

@testset "Canty-Davison Bootstrap Tests" begin
    
    @testset "Function Exists and Basic Functionality" begin
        srs = SurveyDesign(apisrs; weights=:pw)
        Random.seed!(1234)
        
        # Test that function exists and returns correct type
        cd_design = canty_davison_bootstrap(srs; replicates=100)
        @test cd_design isa ReplicateDesign{BootstrapReplicates}
        @test cd_design.replicates == 100
        @test cd_design.type == "canty_davison_bootstrap"
        
        # Test that replicate columns are created
        @test ncol(cd_design.data) == ncol(srs.data) + 100
        @test all(startswith.(string.(names(cd_design.data)[end-99:end]), "replicate_"))
    end
    
    @testset "Clustered Design" begin
        dclus1 = SurveyDesign(apiclus1; clusters=:dnum, weights=:pw)
        Random.seed!(1234)
        
        cd_clus = canty_davison_bootstrap(dclus1; replicates=50)
        @test cd_clus isa ReplicateDesign{BootstrapReplicates}
        @test cd_clus.replicates == 50
        @test cd_clus.type == "canty_davison_bootstrap"
        
        # Test weights are positive (bootstrap can create zero weights)
        for i in 1:50
            replicate_weights = cd_clus.data[!, Symbol("replicate_$(i)")]
            @test all(replicate_weights .>= 0)
        end
    end
    
    @testset "Stratified Design" begin
        dstrat = SurveyDesign(apistrat; strata=:stype, weights=:pw)
        Random.seed!(1234)
        
        cd_strat = canty_davison_bootstrap(dstrat; replicates=50)
        @test cd_strat isa ReplicateDesign{BootstrapReplicates}
        @test cd_strat.replicates == 50
        @test cd_strat.type == "canty_davison_bootstrap"
    end
    
    @testset "Comparison with Rao-Wu Bootstrap" begin
        dclus1 = SurveyDesign(apiclus1; clusters=:dnum, weights=:pw)
        Random.seed!(1234)
        
        # Create both types of bootstrap designs
        rw_design = bootweights(dclus1; replicates=1000)
        Random.seed!(1234)  # Reset seed for fair comparison
        cd_design = canty_davison_bootstrap(dclus1; replicates=1000)
        
        # Both should have same structure but different weights
        @test size(rw_design.data) == size(cd_design.data)
        @test rw_design.type == "bootstrap"
        @test cd_design.type == "canty_davison_bootstrap"
        
        # The replicate weights should be different between the two methods
        # This tests that we're actually implementing a different algorithm
        rw_rep1 = rw_design.data[!, :replicate_1]
        cd_rep1 = cd_design.data[!, :replicate_1]
        @test !all(rw_rep1 .≈ cd_rep1)  # Weights should differ
    end
    
    @testset "Mean Estimation with Standard Errors" begin
        dclus1 = SurveyDesign(apiclus1; clusters=:dnum, weights=:pw)
        Random.seed!(1234)
        cd_design = canty_davison_bootstrap(dclus1; replicates=1000)
        
        # Test mean estimation works
        mean_result = mean(:api00, cd_design)
        @test mean_result isa DataFrame
        @test nrow(mean_result) == 1
        @test "mean" in names(mean_result)
        @test "SE" in names(mean_result)
        @test mean_result.mean[1] > 0
        @test mean_result.SE[1] > 0
    end
    
    @testset "Reproducibility with Same Seed" begin
        dclus1 = SurveyDesign(apiclus1; clusters=:dnum, weights=:pw)
        
        Random.seed!(1234)
        cd_design1 = canty_davison_bootstrap(dclus1; replicates=100)
        
        Random.seed!(1234)
        cd_design2 = canty_davison_bootstrap(dclus1; replicates=100)
        
        # Should get identical results with same seed
        @test all(cd_design1.data[!, :replicate_1] .≈ cd_design2.data[!, :replicate_1])
        @test all(cd_design1.data[!, :replicate_50] .≈ cd_design2.data[!, :replicate_50])
    end
    
    @testset "Different Replicate Counts" begin
        dclus1 = SurveyDesign(apiclus1; clusters=:dnum, weights=:pw)
        
        Random.seed!(1234)
        cd_50 = canty_davison_bootstrap(dclus1; replicates=50)
        cd_100 = canty_davison_bootstrap(dclus1; replicates=100)
        
        @test cd_50.replicates == 50
        @test cd_100.replicates == 100
        @test ncol(cd_50.data) == ncol(dclus1.data) + 50
        @test ncol(cd_100.data) == ncol(dclus1.data) + 100
    end
    
    @testset "Edge Cases" begin
        # Test with minimum viable cluster design
        minimal_data = DataFrame(
            id = 1:6,
            cluster = [1, 1, 2, 2, 3, 3],
            value = [10, 20, 30, 40, 50, 60],
            weights = fill(1.0, 6)
        )
        
        minimal_design = SurveyDesign(minimal_data; clusters=:cluster, weights=:weights)
        Random.seed!(1234)
        
        cd_minimal = canty_davison_bootstrap(minimal_design; replicates=10)
        @test cd_minimal isa ReplicateDesign{BootstrapReplicates}
        @test cd_minimal.replicates == 10
    end
    
    @testset "Weight Properties" begin
        dclus1 = SurveyDesign(apiclus1; clusters=:dnum, weights=:pw)
        Random.seed!(1234)
        cd_design = canty_davison_bootstrap(dclus1; replicates=100)
        
        # Original weights should be preserved
        @test all(cd_design.data[!, cd_design.weights] .== dclus1.data[!, dclus1.weights])
        
        # Replicate weights should be non-negative
        for i in 1:100
            replicate_weights = cd_design.data[!, Symbol("replicate_$(i)")]
            @test all(replicate_weights .>= 0)
        end
        
        # At least some replicate weights should be zero (characteristic of bootstrap)
        has_zero = false
        for i in 1:100
            replicate_weights = cd_design.data[!, Symbol("replicate_$(i)")]
            if any(replicate_weights .== 0)
                has_zero = true
                break
            end
        end
        @test has_zero  # Bootstrap should create some zero weights
    end
end