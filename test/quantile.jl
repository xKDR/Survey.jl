@testset "quantile_SimpleRandomSample" begin
    ##### SimpleRandomSample tests
    # Load API datasets
    apisrs_original = load_data("apisrs")
    apisrs_original[!, :derived_probs] = 1 ./ apisrs_original.pw
    apisrs_original[!, :derived_sampsize] = fill(200.0, size(apisrs_original, 1))
    ##############################
    ### weights or probs as Symbol
    apisrs = copy(apisrs_original)
    srs_design = SimpleRandomSample(apisrs,popsize=:fpc)
    @test quantile(:api00,srs_design,0.5)[!,2] ≈ 659 atol = 1e-4
    @test quantile(:enroll,srs_design,[0.1,0.2,0.5,0.75,0.95])[!,2] ≈ [245.5,317.6,453.0,668.5,1473.1] atol = 1e-4 
end

@testset "quantile_Stratified" begin
    ## Add tests
end

@testset "quantile_by_SimpleRandomSample" begin
    ## Add tests
end

@testset "quantile_by_Stratified" begin
    ## Add tests
end