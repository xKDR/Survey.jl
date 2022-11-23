@testset "SimpleRandomSample" begin
    ##### SimpleRandomSample tests
    # Load API datasets
    apisrs_original = load_data("apisrs")
    # Work on copies, keep original
    
    # Test: with popsize == ::Symbol
    apisrs1 = copy(apisrs_original)
    srs = SimpleRandomSample(apisrs1; popsize = apisrs1.fpc)
    @test srs.data.weights == 1 ./ srs.data.probs # weights should be inverse of probs
    @test srs.sampsize > 0

    apisrs1 = copy(apisrs_original)
    srs = SimpleRandomSample(apisrs1; popsize = :fpc)
    @test srs.data.weights == 1 ./ srs.data.probs # weights should be inverse of probs
    @test srs.sampsize > 0
    
    apisrs2 = copy(apisrs_original)
    srs_weights = SimpleRandomSample(apisrs2; weights = apisrs2.pw )
    @test srs_weights.data.weights[1] == 30.97
    @test srs_weights.data.weights == 1 ./ srs_weights.data.probs
    
    apisrs2 = copy(apisrs_original)
    srs_freq = SimpleRandomSample(apisrs2; probs = 1 ./ apisrs2.pw )
    @test srs_freq.data.weights[1] == 30.97
    @test srs_freq.data.weights == 1 ./ srs_freq.data.probs

    apisrs3 = copy(apisrs_original)
    srs_weights = SimpleRandomSample(apisrs3, ignorefpc = false, weights = :pw)
    
    @test_throws ErrorException SimpleRandomSample(apisrs3, ignorefpc = false, weights = :stype)
    
    apisrs4 = copy(apisrs_original)
    srs_w_p = SimpleRandomSample(apisrs4, ignorefpc = false, popsize = :fpc, probs = fill(0.3, size(apisrs_original, 1)))
    @test srs_w_p.data.probs == 1 ./ srs_w_p.data.weights
    @test sum(srs_w_p.data.probs) == 1
    
    apisrs5 = copy(apisrs_original)
    srs = SimpleRandomSample(apisrs5, ignorefpc = true, probs = 1 ./ apisrs5.pw )
    @test srs.data.probs == 1 ./ srs.data.weights
    apisrs6 = copy(apisrs_original)
    @test_throws ErrorException SimpleRandomSample(apisrs6, popsize = -2.8, ignorefpc = true)# the errror is wrong
    # @test_throws SimpleRandomSample(apisrs6, sampsize = -2.8, ignorefpc = true)# the function is working upto line 55


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
  apistrat_original = load_data("apistrat")
  apistrat1 = copy(apistrat_original)
  strat = StratifiedSample(apistrat1, :stype ; popsize = :fpc )
  @test strat.data.probs == 1 ./ strat.data.weights
  
  apistrat2 = copy(apistrat_original)
  strat_wt = StratifiedSample(apistrat2, :stype ; weights = :pw)
  @test strat_wt.data.probs == 1 ./ strat_wt.data.weights
  
  apistrat3 = copy(apistrat_original)
  strat_probs = StratifiedSample(apistrat3, :stype ; probs = 1 ./ apistrat3.pw)
  @test strat_probs.data.probs == 1 ./ strat_probs.data.weights
  
  #see github issue for srs
  apistrat4 = copy(apistrat_original)
  strat_probs1 = StratifiedSample(apistrat4, :stype; probs = fill(0.3, size(apistrat4, 1)))
  #@test strat_probs1.data.probs == 1 ./ strat_probs1.data.weights
  
  apistrat5 = copy(apistrat_original)
  strat_popsize = StratifiedSample(apistrat5, :stype; popsize= apistrat5.fpc)
  @test strat_popsize.data.probs == 1 ./ strat_popsize.data.weights
  
  # To edit
  # strat_popsize_fpc = StratifiedSample(apistrat, :stype; popsize= apistrat.fpc, ignorefpc = true)
  # strat_new = StratifiedSample(apistrat, :stype; popsize= apistrat.pw, sampsize = apistrat.fpc) #should throw error because sampsize > popsize
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
