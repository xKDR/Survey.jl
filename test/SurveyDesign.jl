@testset "SurveyDesign.jl" begin
    ##### SimpleRandomSample tests
    # Load API datasets
    apisrs_original   = load_data("apisrs")
    apistrat_original = load_data("apistrat")
    apiclus1_original = load_data("apiclus1")
    apiclus2_original = load_data("apiclus2")
    # Work on copy, keep original
    apisrs   = copy(apisrs_original)
    apistrat = copy(apistrat_original)
    apiclus1 = copy(apiclus1_original)
    apiclus2 = copy(apiclus2_original)

    srs = SimpleRandomSample(apisrs, popsize = apisrs.fpc)
    @test srs.data.weights == 1 ./ srs.data.probs # weights should be inverse of probs
    @test srs.sampsize > 0

    srs_freq = SimpleRandomSample(apisrs; weights = apisrs.pw )
    @test srs_freq.data.weights[1] == 30.97
    @test srs_freq.data.weights == 1 ./ srs_freq.data.probs

    srs_weights = SimpleRandomSample(apisrs, ignorefpc = false, weights = :fpc)
    @test_throws srs_weights = SimpleRandomSample(apisrs, ignorefpc = false, weights = :stype)
    srs_w_p = SimpleRandomSample(apisrs, ignorefpc = false, weights = :fpc, probs = fill(0.3, size(apisrs_original, 1)))
    @test srs_w_p.data.probs == 1 ./ srs_w_p.data.weights
    @test sum(srs_w_p.data.probs) == 1

    srs = SimpleRandomSample(apisrs, ignorefpc = true, probs = 1 ./ apisrs.pw )
    @test srs.data.probs == 1 ./ srs.data.weights
    @test_throws srs = SimpleRandomSample(apisrs, popsize = -2.8, ignorefpc = true)# the errror is wrong
    @test_throws srs = SimpleRandomSample(apisrs, sampsize = -2.8, ignorefpc = true)# the function is working upto line 55


    ##### TODO: needs change; this works but isn't what the user is expecting
    # srs_prob = SimpleRandomSample(apisrs; probs = 1 ./ apisrs.pw)
    # @test srs_prob.data.probs[1] == 0.3

    #### TODO: StratifiedSample tests
        # ... @sayantika @iulia @shikhar
        # apistrat examples from R, check the main if-else cases

        # Test with probs = , weight = , and popsize = arguments, as vectors and sybols

end

@testset "StratifiedSample" begin
  # StratifiedSample tests   
  apistrat = load_data("apistrat")
  strat = StratifiedSample(apistrat, :stype ; popsize = apistrat.fpc )
  @test strat.data.probs == 1 ./ strat.data.weights

  strat_wt = StratifiedSample(apistrat, :stype ; weights = :pw)
  @test strat_wt.data.probs == 1 ./ strat_wt.data.weights
  
  strat_probs = StratifiedSample(apistrat, :stype ; probs = 1 ./ apistrat.pw)
  @test strat_probs.data.probs == 1 ./ strat_probs.data.weights
  
  strat_probs1 = StratifiedSample(apistrat, :stype; probs = fill(0.3, size(apistrat, 1)))
  @test strat_probs1.data.probs == 1 ./ strat_probs1.data.weights
  
  strat_popsize = StratifiedSample(apistrat, :stype; popsize= apistrat.fpc)
  @test strat_popsize.data.probs == 1 ./ strat_popsize.data.weights
  
  strat_popsize_fpc = StratifiedSample(apistrat, :stype; popsize= apistrat.fpc, ignorefpc = true)
  
  strat_new = StratifiedSample(apistrat, :stype; popsize= apistrat.pw, sampsize = apistrat.fpc) #should throw error
end

##### SurveyDesign tests
@testset "SurveyDesign" begin
    # Case 1: Simple Random Sample
    svydesign1 = SurveyDesign(apisrs, popsize = apisrs.fpc)
    @test svydesign1.data.weights == 1 ./ svydesign1.data.probs # weights should be inverse of probs
    @test svydesign1.sampsize > 0

    # Case 1b: SRS 'with replacement' approximation ie ignorefpc = true
    svydesign2 = SurveyDesign(apisrs, popsize = apisrs.fpc, ignorefpc = true)
    @test svydesign2.data.weights == 1 ./ svydesign2.data.probs # weights should be inverse of probs
    @test svydesign2.sampsize > 0

    # Case 2: Stratified Random Sample
    # strat_design = SurveyDesign(apistrat,strata = :stype, popsize =:fpc, ignorefpc = false)
    
    # Case: Arbitrary weights

    # Case: One-stage cluster sampling, no strata

    # Case: One-stage cluster sampling, with one-stage strata

    # Case: Two cluster, two strata
    
    # Case: Multi stage stratified design
end