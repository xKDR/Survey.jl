@testset "SurveyDesign_srs" begin
    ##### Simple Random Sample tests
    # Load API datasets
    apisrs_original = load_data("apisrs")
    apisrs_original[!, :derived_probs] = 1 ./ apisrs_original.pw
    apisrs_original[!, :derived_sampsize] = fill(200.0, size(apisrs_original, 1))
    ##############################
    ### Basic functionality
    ### weights as Symbol
    apisrs = copy(apisrs_original)
    srs_weights = SurveyDesign(apisrs, weights=:pw)
    @test srs_weights.data[!,srs_weights.weights][1] ≈ 30.97 atol = 1e-4
    @test srs_weights.data[!,srs_weights.weights] == 1 ./ srs_weights.data[!,srs_weights.allprobs]
    ### popsize as Symbol
    apisrs = copy(apisrs_original)
    srs_pop = SurveyDesign(apisrs, popsize=:fpc)
    @test srs_pop.data[!,srs_pop.weights][1] ≈ 30.97 atol = 1e-4
    @test srs_pop.data[!,srs_pop.weights] == 1 ./ srs_pop.data[!,srs_pop.allprobs]
    ### Both ways should achieve same weights and allprobs!
    @test srs_pop.data[!,srs_pop.weights] == srs_weights.data[!,srs_weights.weights]
    ##############################
    ### Weights as non-numeric error
    apisrs = copy(apisrs_original)
    @test_throws ArgumentError SurveyDesign(apisrs, weights=:stype)
end

@testset "SurveyDesign_strat" begin
    ### StratifiedSample tests
    # Load API datasets
    apistrat_original = load_data("apistrat")
    apistrat_original[!, :derived_probs] = 1 ./ apistrat_original.pw
    apistrat_original[!, :derived_sampsize] = apistrat_original.fpc ./ apistrat_original.pw
    ##############################
    ### weights as Symbol
    apistrat = copy(apistrat_original)
    strat_wt = SurveyDesign(apistrat, strata=:stype, weights=:pw)
    @test strat_wt.data[!,strat_wt.weights][1] ≈ 44.2100 atol = 1e-4
    @test strat_wt.data[!,strat_wt.weights][200] ≈ 15.1000 atol = 1e-4
    @test strat_wt.data[!,strat_wt.weights] == 1 ./ strat_wt.data[!,strat_wt.allprobs]
    ### popsize as Symbol (should be same as above)
    apistrat = copy(apistrat_original)
    strat_pop = SurveyDesign(apistrat, strata=:stype, popsize=:fpc)
    @test strat_pop.data[!,strat_pop.weights][1] ≈ 44.2100 atol = 1e-4
    @test strat_pop.data[!,strat_pop.weights][200] ≈ 15.1000 atol = 1e-4
    @test strat_pop.data[!,strat_pop.weights] == 1 ./ strat_pop.data[!,strat_pop.allprobs]
    ### popsize and weights as Symbol (should be same as above two)
    apistrat = copy(apistrat_original)
    dstrat = SurveyDesign(apistrat, strata=:stype, weights=:pw, popsize=:fpc)
    @test dstrat.data[!,dstrat.weights][1] ≈ 44.2100 atol = 1e-4
    @test dstrat.data[!,dstrat.weights][200] ≈ 15.1000 atol = 1e-4
    @test dstrat.data[!,dstrat.weights] == 1 ./ dstrat.data[!,dstrat.allprobs]
    ##############################
    # Check all three ways get equivalent weights
    @test strat_pop.data[!,strat_pop.weights] ≈ strat_wt.data[!,strat_wt.weights] rtol = 1e-4
    @test strat_wt.data[!,strat_wt.weights] ≈ strat_wt.data[!,strat_wt.weights] rtol = 1e-4
end

@testset "SurveyDesign_multistage" begin
    # Load API datasets
    apiclus1_original = load_data("apiclus1")
    apiclus1_original[!, :pw] = fill(757/15,(size(apiclus1_original,1),)) # Correct api mistake for pw column
    ##############################
    # one-stage cluster sample with popsize
    apiclus1 = copy(apiclus1_original)
    dclus1 = SurveyDesign(apiclus1; clusters = :dnum, popsize =:fpc)
    @test dclus1.data[!, dclus1.weights] ≈ fill(50.4667,size(apiclus1,1)) atol = 1e-3
    @test dclus1.data[!, dclus1.sampsize] ≈ fill(15,size(apiclus1,1))
    ##############################
    # Load API datasets
    nhanes = load_data("nhanes")
    nhanes_design = SurveyDesign(nhanes; clusters = :SDMVPSU, strata = :SDMVSTRA, weights = :WTMEC2YR)
end

@testset "SurveyDesign_realSurveys" begin
    # Load API datasets
    yrbs_original = load_data("yrbs")
    nhanes_original = load_data("nhanes")
    ##############################
    # NHANES
    nhanes = copy(nhanes_original)
    dnhanes = SurveyDesign(nhanes; clusters = :SDMVPSU, strata=:SDMVSTRA, weights=:WTMEC2YR)
    ##############################
    # YRBS
    yrbs = copy(yrbs_original)
    dyrbs = SurveyDesign(yrbs; clusters = :psu, strata=:stratum, weights=:weight)
end
