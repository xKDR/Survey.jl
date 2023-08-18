@testset "SurveyDesign_srs" begin
    ##### Simple Random Sample tests
    # Load API datasets
    apisrs_original = load_data("apisrs")
    apisrs_original[!, :derived_probs] = 1 ./ apisrs_original.pw
    apisrs_original[!, :derived_sampsize] = fill(200.0, size(apisrs_original, 1))
    ##############################
    # Test unweighted case, when neither popsize nor weights are given
    apisrs = copy(apisrs_original)
    srs_unweighted = SurveyDesign(apisrs)
    @test srs_unweighted.data[!, srs_unweighted.weights][1] ≈ 1 atol = 1e-4
    @test srs_unweighted.data[!, srs_unweighted.sampsize][1] ≈ 200 atol = 1e-4
    @test srs_unweighted.data[!, srs_unweighted.popsize][1] ≈ 200 atol = 1e-4
    ##############################
    ### Basic functionality
    ### weights as Symbol
    apisrs = copy(apisrs_original)
    srs_weights = SurveyDesign(apisrs, weights = :pw)
    @test srs_weights.data[!, srs_weights.weights][1] ≈ 30.97 atol = 1e-4
    @test srs_weights.data[!, srs_weights.weights] ==
          1 ./ srs_weights.data[!, srs_weights.allprobs]
    @test srs_weights.data[!, srs_weights.allprobs] ≈ srs_weights.data[!, :derived_probs] atol =
        1e-4
    @test srs_weights.data[!, srs_weights.sampsize] ≈ srs_weights.data[!, :derived_sampsize] atol =
        1e-4
    ### popsize as Symbol
    apisrs = copy(apisrs_original)
    srs_pop = SurveyDesign(apisrs, popsize = :fpc)
    @test srs_pop.data[!, srs_pop.weights][1] ≈ 30.97 atol = 1e-4
    @test srs_pop.data[!, srs_pop.weights] == 1 ./ srs_pop.data[!, srs_pop.allprobs]
    @test srs_pop.data[!, srs_pop.allprobs] ≈ srs_pop.data[!, :derived_probs] atol = 1e-4
    @test srs_pop.data[!, srs_pop.sampsize] ≈ srs_pop.data[!, :derived_sampsize] atol = 1e-4
    ### Both ways should achieve same weights and allprobs!
    @test srs_pop.data[!, srs_pop.weights] == srs_weights.data[!, srs_weights.weights]
    ##############################
    ### Weights as non-numeric error
    apisrs = copy(apisrs_original)
    @test_throws ArgumentError SurveyDesign(apisrs, weights = :stype)

    ### popsize and weights as symbols

    apisrs = copy(apisrs_original)
    srs_pop_weights = SurveyDesign(apisrs, weights =:pw, popsize = :fpc)
    @test srs_pop_weights.data[!, srs_pop_weights.weights][1] ≈ 30.97 atol = 1e-4
    @test srs_pop_weights.data[!, srs_pop_weights.weights] == 1 ./ srs_pop_weights.data[!, srs_pop_weights.allprobs]
    @test srs_pop_weights.data[!, srs_pop_weights.allprobs] ≈ srs_pop_weights.data[!, :derived_probs] atol = 1e-4
    @test srs_pop_weights.data[!, srs_pop_weights.sampsize] ≈ srs_pop_weights.data[!, :derived_sampsize] atol = 1e-4
    ### Both ways should achieve same weights and allprobs!
    @test srs_pop_weights.data[!, srs_pop_weights.weights] == srs_weights.data[!, srs_weights.weights]

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
    strat_wt = SurveyDesign(apistrat, strata = :stype, weights = :pw)
    @test strat_wt.data[!, strat_wt.weights][1] ≈ 44.2100 atol = 1e-4
    @test strat_wt.data[!, strat_wt.weights][200] ≈ 15.1000 atol = 1e-4
    @test strat_wt.data[!, strat_wt.weights] == 1 ./ strat_wt.data[!, strat_wt.allprobs]
    @test strat_wt.data[!, strat_wt.allprobs] ≈ strat_wt.data[!, :derived_probs] atol = 1e-4
    @test strat_wt.data[!, strat_wt.sampsize] ≈ strat_wt.data[!, :derived_sampsize] atol =
        1e-4
    ### popsize as Symbol (should be same as above (for now))
    apistrat = copy(apistrat_original)
    strat_pop = SurveyDesign(apistrat, strata = :stype, popsize = :fpc)
    @test strat_pop.data[!, strat_pop.weights][1] ≈ 44.2100 atol = 1e-4
    @test strat_pop.data[!, strat_pop.weights][200] ≈ 15.1000 atol = 1e-4
    @test strat_pop.data[!, strat_pop.weights] == 1 ./ strat_pop.data[!, strat_pop.allprobs]
    @test strat_pop.data[!, strat_pop.allprobs] ≈ strat_pop.data[!, :derived_probs] atol =
        1e-4
    @test strat_pop.data[!, strat_pop.sampsize] ≈ strat_pop.data[!, :derived_sampsize] atol =
        1e-4
    ### popsize and weights as Symbol (should be same as above two)
    apistrat = copy(apistrat_original)
    dstrat = SurveyDesign(apistrat, strata = :stype, weights = :pw, popsize = :fpc)
    @test dstrat.data[!, dstrat.weights][1] ≈ 44.2100 atol = 1e-4
    @test dstrat.data[!, dstrat.weights][200] ≈ 15.1000 atol = 1e-4
    @test dstrat.data[!, dstrat.weights] == 1 ./ dstrat.data[!, dstrat.allprobs]
    @test dstrat.data[!, dstrat.allprobs] ≈ dstrat.data[!, :derived_probs] atol = 1e-4
    @test dstrat.data[!, dstrat.sampsize] ≈ dstrat.data[!, :derived_sampsize] atol = 1e-4
    ##############################
    # Check all three ways get equivalent weights
    @test strat_pop.data[!, strat_pop.weights] ≈ strat_wt.data[!, strat_wt.weights] rtol =
        1e-4
    @test strat_wt.data[!, strat_wt.weights] ≈ strat_wt.data[!, strat_wt.weights] rtol =
        1e-4
end

@testset "SurveyDesign_apiclus1" begin
    # Load API datasets
    apiclus1_original = load_data("apiclus1")
    apiclus1_original[!, :pw] = fill(757 / 15, (size(apiclus1_original, 1),)) # Correct api mistake for pw column
    apiclus1_original[!, :derived_probs] = 1 ./ apiclus1_original.pw
    ##############################
    # one-stage cluster sample with popsize
    apiclus1 = copy(apiclus1_original)
    dclus1 = SurveyDesign(apiclus1; clusters = :dnum, popsize = :fpc)
    @test dclus1.data[!, dclus1.weights] ≈ fill(50.4667, size(apiclus1, 1)) atol = 1e-3
    @test dclus1.data[!, dclus1.sampsize] ≈ fill(15, size(apiclus1, 1))
    @test dclus1.data[!, dclus1.allprobs] ≈ dclus1.data[!, :derived_probs] atol = 1e-4
end

@testset "SurveyDesign_apiclus2" begin
    # Load API datasets
    apiclus2_original = load_data("apiclus2")
    apiclus2_original[!, :derived_probs] = 1 ./ apiclus2_original.pw
    ##############################
    calculated_probs_R = [
        0.052840159,
        0.052840159,
        0.052840159,
        0.052840159,
        0.052840159,
        0.052840159,
        0.052840159,
        0.052840159,
        0.052840159,
        0.052840159,
        0.052840159,
        0.052840159,
        0.052840159,
        0.052840159,
        0.052840159,
        0.052840159,
        0.052840159,
        0.052840159,
        0.052840159,
        0.052840159,
        0.052840159,
        0.024018254,
        0.024018254,
        0.024018254,
        0.024018254,
        0.024018254,
        0.052840159,
        0.052840159,
        0.052840159,
        0.052840159,
        0.052840159,
        0.052840159,
        0.052840159,
        0.052840159,
        0.052840159,
        0.052840159,
        0.052840159,
        0.052840159,
        0.052840159,
        0.052840159,
        0.052840159,
        0.052840159,
        0.052840159,
        0.052840159,
        0.052840159,
        0.052840159,
        0.052840159,
        0.052840159,
        0.052840159,
        0.052840159,
        0.052840159,
        0.052840159,
        0.052840159,
        0.052840159,
        0.052840159,
        0.052840159,
        0.052840159,
        0.052840159,
        0.052840159,
        0.052840159,
        0.052840159,
        0.052840159,
        0.052840159,
        0.052840159,
        0.052840159,
        0.052840159,
        0.052840159,
        0.007338911,
        0.007338911,
        0.007338911,
        0.007338911,
        0.007338911,
        0.052840159,
        0.009435743,
        0.009435743,
        0.009435743,
        0.009435743,
        0.009435743,
        0.037742970,
        0.037742970,
        0.037742970,
        0.037742970,
        0.037742970,
        0.003669455,
        0.003669455,
        0.003669455,
        0.003669455,
        0.003669455,
        0.018871485,
        0.018871485,
        0.018871485,
        0.018871485,
        0.018871485,
        0.037742970,
        0.037742970,
        0.037742970,
        0.037742970,
        0.037742970,
        0.052840159,
        0.052840159,
        0.052840159,
        0.052840159,
        0.052840159,
        0.052840159,
        0.052840159,
        0.052840159,
        0.052840159,
        0.052840159,
        0.052840159,
        0.052840159,
        0.052840159,
        0.052840159,
        0.029355644,
        0.029355644,
        0.029355644,
        0.029355644,
        0.029355644,
        0.052840159,
        0.052840159,
        0.052840159,
        0.044033465,
        0.044033465,
        0.044033465,
        0.044033465,
        0.044033465,
        0.052840159,
    ]

    # two stage cluster sampling `with replacement'
    apiclus2 = copy(apiclus2_original)
    dclus2 = SurveyDesign(apiclus2; clusters = [:dnum, :snum], weights = :pw) # cant pass popsize as Vector
    @test dclus2.data[!, dclus2.weights][1] ≈ 1 / calculated_probs_R[1] atol = 1e-4
    @test dclus2.data[!, dclus2.weights][25] ≈ 1 / calculated_probs_R[25] atol = 1e-4
    @test dclus2.data[!, dclus2.weights][121] ≈ 1 / calculated_probs_R[121] atol = 1e-4
    @test dclus2.data[!, dclus2.weights][125] ≈ 1 / calculated_probs_R[125] atol = 1e-4

    # TODO: sampsize and popsize testing once #178 resolved
    ## NOT THE SAME AS R object right now

    #########################
    ## Complete multistage sampling (when implemented) should look like
    ## weights should theoretically be optional if both clusters and popsize given
    # dclus2_complete = SurveyDesign(apiclus2; clusters = [:dnum,:snum], popsize=[:fpc1,:fpc2], {weights=:pw})
end

@testset "SurveyDesign_realSurveys" begin
    # Load API datasets
    yrbs_original = load_data("yrbs")
    nhanes_original = load_data("nhanes")
    ##############################
    # NHANES
    nhanes = copy(nhanes_original)
    dnhanes =
        SurveyDesign(nhanes; clusters = :SDMVPSU, strata = :SDMVSTRA, weights = :WTMEC2YR)
    ##############################
    # YRBS
    yrbs = copy(yrbs_original)
    dyrbs = SurveyDesign(yrbs; clusters = :psu, strata = :stratum, weights = :weight)
end

@testset "ReplicateDesign_direct" begin
    for (sample, sample_direct) in [(bsrs, bsrs_direct), (bstrat, bstrat_direct), (dclus1_boot, dclus1_boot_direct)]
        @test isequal(sample.data, sample_direct.data)
        @test isequal(sample.popsize, sample_direct.popsize)
        @test isequal(sample.sampsize, sample_direct.sampsize)
        @test isequal(sample.strata, sample_direct.strata)
        @test isequal(sample.weights, sample_direct.weights)
        @test isequal(sample.allprobs, sample_direct.allprobs)
        @test isequal(sample.pps, sample_direct.pps)
        @test isequal(sample.replicates, sample_direct.replicates)
        @test isequal(sample.replicate_weights, sample_direct.replicate_weights)
    end
end

@testset "ReplicateDesign_unitrange" begin
    for (sample, sample_unitrange) in [(bsrs, bsrs_unitrange), (bstrat, bstrat_unitrange), (dclus1_boot, dclus1_boot_unitrange)]
        @test isequal(sample.data, sample_unitrange.data)
        @test isequal(sample.popsize, sample_unitrange.popsize)
        @test isequal(sample.sampsize, sample_unitrange.sampsize)
        @test isequal(sample.strata, sample_unitrange.strata)
        @test isequal(sample.weights, sample_unitrange.weights)
        @test isequal(sample.allprobs, sample_unitrange.allprobs)
        @test isequal(sample.pps, sample_unitrange.pps)
        @test isequal(sample.replicates, sample_unitrange.replicates)
        @test isequal(sample.replicate_weights, sample_unitrange.replicate_weights)
    end
end

@testset "ReplicateDesign_regex" begin
    for (sample, sample_regex) in [(bsrs, bsrs_regex), (bstrat, bstrat_regex), (dclus1_boot, dclus1_boot_regex)]
        @test isequal(sample.data, sample_regex.data)
        @test isequal(sample.popsize, sample_regex.popsize)
        @test isequal(sample.sampsize, sample_regex.sampsize)
        @test isequal(sample.strata, sample_regex.strata)
        @test isequal(sample.weights, sample_regex.weights)
        @test isequal(sample.allprobs, sample_regex.allprobs)
        @test isequal(sample.pps, sample_regex.pps)
        @test isequal(sample.replicates, sample_regex.replicates)
        @test isequal(sample.replicate_weights, sample_regex.replicate_weights)
    end
end
