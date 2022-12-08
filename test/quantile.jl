@testset "quantile_SimpleRandomSample" begin
    ##### SimpleRandomSample tests
    # Load API datasets
    apisrs_original = load_data("apisrs")
    apisrs_original[!, :derived_probs] = 1 ./ apisrs_original.pw
    apisrs_original[!, :derived_sampsize] = fill(200.0, size(apisrs_original, 1))
    ##############################
    apisrs = copy(apisrs_original)
    srs_design = SimpleRandomSample(apisrs,popsize=:fpc)
    @test quantile(:api00,srs_design,0.5)[!,2][1] ≈ 659.0 atol=1e-4
    @test quantile(:api00,srs_design,[0.1753,0.25,0.5,0.75,0.975])[!,2] ≈ [512.8847,544,659,752.5,905] atol = 1e-4
    @test quantile(:enroll,srs_design,[0.1,0.2,0.5,0.75,0.95])[!,2] ≈ [245.5,317.6,453.0,668.5,1473.1] atol = 1e-4 
end

@testset "quantile_Stratified" begin
    ##### StratifiedSample tests
    # Load API datasets
    apistrat_original = load_data("apistrat")
    apistrat_original[!, :derived_probs] = 1 ./ apistrat_original.pw
    apistrat_original[!, :derived_sampsize] = apistrat_original.fpc ./ apistrat_original.pw
    # base functionality
    apistrat = copy(apistrat_original)
    dstrat = StratifiedSample(apistrat, :stype; popsize = :fpc)
    # Check which definition of quantile for StratifiedSample
    # @test quantile(:enroll,dstrat,[0.1,0.2,0.5,0.75,0.95])[!,2] ≈ [262,309.3366,446.4103,658.8764,1589.7881] atol = 1e-4 
end

@testset "quantile_by_SimpleRandomSample" begin
    ## Add tests
end

@testset "quantile_by_Stratified" begin
    ## Add tests
end