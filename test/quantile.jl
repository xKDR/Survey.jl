@testset "quantile_SimpleRandomSample" begin
    ##### SimpleRandomSample tests
    # Load API datasets
    apisrs_original = load_data("apisrs")
    apisrs_original[!, :derived_probs] = 1 ./ apisrs_original.pw
    apisrs_original[!, :derived_sampsize] = fill(200.0, size(apisrs_original, 1))
    ##############################
    apisrs = copy(apisrs_original)
    srs_design = SurveyDesign(apisrs; weights=:pw) |> bootweights
    @test quantile(:api00, srs_design, 0.5)[!,1][1] ≈ 659.0 atol=1e-4
    @test quantile(:api00, srs_design, [0.1753,0.25,0.5,0.75,0.975])[!,2] ≈ [512.8847,544,659,752.5,905] atol = 1e-4
    @test quantile(:enroll,srs_design, [0.1,0.2,0.5,0.75,0.95])[!,2] ≈ [245.5,317.6,453.0,668.5,1473.1] atol = 1e-4 
end