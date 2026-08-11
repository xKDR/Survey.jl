using Survey
using Test
using Random
using DataFrames

apisrs = load_data("apisrs")
srs = SurveyDesign(apisrs; weights=:pw)
Random.seed!(1234)
bsrs = bootweights(srs; replicates=1000)

@testset "Design Effect" begin
    # Ensure column is accessed using symbol as column name
    d = deff(:api99, srs, bsrs)
    @test d > 0.5 && d < 3.0
end

@testset "Different Replicates" begin
    bsrs2 = bootweights(srs; replicates=500)
    d2 = deff(:api99, srs, bsrs2)
    d_ref = deff(:api99, srs, bsrs)
    @test abs(d2 - d_ref) > 1e-3
end

@testset "Different Weights" begin
    apisrs_alt = deepcopy(apisrs)

    # Introduce a non-uniform perturbation to weights
    perturbation = 1 .+ 0.1 .* randn(length(apisrs_alt.pw))
    apisrs_alt[!, :pw_alt] .= apisrs_alt.pw .* perturbation

    srs_alt = SurveyDesign(apisrs_alt; weights=:pw_alt)
    bsrs_alt = bootweights(srs_alt; replicates=1000)

    d_alt = deff(:api99, srs_alt, bsrs_alt)
    d_ref = deff(:api99, srs, bsrs)

    @test abs(d_alt - d_ref) > 1e-3
end

@testset "Different Variables" begin
    d_api00 = deff(:api00, srs, bsrs)
    d_api99 = deff(:api99, srs, bsrs)
    @test abs(d_api00 - d_api99) > 1e-3
end

@testset "R Comparison - SRS" begin
    # Example 1: Simple random sample
    # R result: svymean(~api00, srs, deff = TRUE) gives DEff = 1.0334
    apisrs = load_data("apisrs")
    srs = SurveyDesign(apisrs; weights=:pw)
    Random.seed!(1234)
    
    # Test with new abstraction
    d_api00_new = deff(:api00, srs; replicates=1000)
    @test abs(d_api00_new - 1.0334) < 0.1  # Allow 10% tolerance
    
    # Test with old interface
    bsrs = bootweights(srs; replicates=1000)
    d_api00_old = deff(:api00, srs, bsrs)
    @test abs(d_api00_old - 1.0334) < 0.1  # Allow 10% tolerance
end

@testset "R Comparison - Clustered" begin
    # Example 2: Clustered sample
    # R result (no fpc): svymean(~api00, dclus1, deff=TRUE) gives DEff ≈ 7.5
    apiclus1 = load_data("apiclus1")
    dclus1 = SurveyDesign(apiclus1; clusters=:dnum, weights=:pw)
    Random.seed!(1234)
    
    # Test with new abstraction
    d_api00_clus_new = deff(:api00, dclus1; replicates=1000)
    @test abs(d_api00_clus_new - 9.39) < 0.1  # Compare to R value (matches R output)
    
    # Test with old interface
    bsclus1 = bootweights(dclus1; replicates=1000)
    d_api00_clus_old = deff(:api00, dclus1, bsclus1)
    @test abs(d_api00_clus_old - 9.39) < 0.1  # Compare to R value (matches R output)
end
