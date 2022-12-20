# Work on copies, keep original
@testset "SimpleRandomSample" begin
    ##### SimpleRandomSample tests
    # Load API datasets
    apisrs_original = load_data("apisrs")
    apisrs_original[!, :derived_probs] = 1 ./ apisrs_original.pw
    apisrs_original[!, :derived_sampsize] = fill(200.0, size(apisrs_original, 1))
    ##############################
    ### Valid type checking tests
    apisrs = copy(apisrs_original)
    @test_throws TypeError SimpleRandomSample(apisrs, popsize=-2.83, ignorefpc=true)
    @test_throws TypeError SimpleRandomSample(apisrs, sampsize=-300)
    @test_throws TypeError SimpleRandomSample(apisrs, sampsize=-2.8, ignorefpc=true)
    @test_throws TypeError SimpleRandomSample(apisrs, weights=50)
    @test_throws TypeError SimpleRandomSample(apisrs, probs=1)
    ##############################
    ### weights or probs as Symbol
    apisrs = copy(apisrs_original)
    srs_weights = SimpleRandomSample(apisrs; weights=:pw)
    @test srs_weights.data.weights[1] ≈ 30.97 atol = 1e-4
    @test srs_weights.data.weights == 1 ./ srs_weights.data.probs
    ### probs as Symbol
    apisrs = copy(apisrs_original)
    srs_probs_sym = SimpleRandomSample(apisrs; probs=:derived_probs)
    @test srs_probs_sym.data.probs[1] ≈ 0.032289 atol = 1e-4
    @test srs_probs_sym.data.probs == 1 ./ srs_probs_sym.data.weights
    ##############################
    ### Weights or probs as non-numeric error
    apisrs = copy(apisrs_original)
    @test_throws ErrorException SimpleRandomSample(apisrs, weights=:stype)
    @test_throws ErrorException SimpleRandomSample(apisrs, probs=:cname)
    ##############################
    ### popsize given as Symbol
    apisrs = copy(apisrs_original)
    srs_popsize_sym = SimpleRandomSample(apisrs; popsize=:fpc)
    @test srs_popsize_sym.data.weights == 1 ./ srs_popsize_sym.data.probs # weights should be inverse of probs
    @test srs_popsize_sym.sampsize > 0
    ### popsize given as Vector
    apisrs = copy(apisrs_original)
    srs_popsize_vec = SimpleRandomSample(apisrs; popsize=apisrs.fpc)
    @test srs_popsize_vec.data.weights == 1 ./ srs_popsize_vec.data.probs # weights should be inverse of probs
    @test srs_popsize_vec.sampsize > 0
    ##############################
    ### sampsize given as Symbol
    apisrs = copy(apisrs_original)
    srs_sampsize_sym = SimpleRandomSample(apisrs; sampsize=:derived_sampsize, weights=:pw)
    @test srs_sampsize_sym.data.weights == 1 ./ srs_sampsize_sym.data.probs # weights should be inverse of probs
    @test srs_sampsize_sym.sampsize > 0
    ### sampsize given as Vector
    apisrs = copy(apisrs_original)
    srs_sampsize_vec = SimpleRandomSample(apisrs; sampsize=apisrs.derived_sampsize, probs=:derived_probs)
    @test srs_sampsize_vec.data.weights == 1 ./ srs_sampsize_vec.data.probs # weights should be inverse of probs
    @test srs_sampsize_vec.sampsize > 0
    ##############################
    ### both weights and probs given
    # If weights given, probs is superfluous
    apisrs = copy(apisrs_original)
    srs_weights_probs = SimpleRandomSample(apisrs; weights=:pw, probs=:derived_probs)
    srs_weights_probs = SimpleRandomSample(apisrs; weights=:pw, probs=:pw)
    ##############################
    ### sum of weights and probs condition check
    apisrs = copy(apisrs_original)
    @test_throws ErrorException SimpleRandomSample(apisrs, weights=fill(0.3, size(apisrs_original, 1)))
    apisrs = copy(apisrs_original)
    @test_throws ErrorException SimpleRandomSample(apisrs, probs=fill(0.3, size(apisrs_original, 1)))
    ##############################
    ### weights only as Vector
    apisrs = copy(apisrs_original)
    srs_weights = SimpleRandomSample(apisrs; weights=apisrs.pw)
    @test srs_weights.data.weights[1] == 30.97
    @test srs_weights.data.weights == 1 ./ srs_weights.data.probs
    ### probs only as Vector
    apisrs = copy(apisrs_original)
    srs_freq = SimpleRandomSample(apisrs; probs=apisrs.derived_probs)
    @test srs_freq.data.weights[1] == 30.97
    @test srs_freq.data.weights == 1 ./ srs_freq.data.probs
    ##############################
    ### ignorefpc tests. TODO: change if ignorefpc functionality changed
    apisrs = copy(apisrs_original)
    srs_ignorefpc = SimpleRandomSample(apisrs; popsize=:fpc, ignorefpc=true)
    @test srs_ignorefpc.data.weights == 1 ./ srs_ignorefpc.data.probs # weights should be inverse of probs
    @test srs_ignorefpc.sampsize > 0
    ### incorrect probs with correct popsize, ignorefpc = true
    apisrs = copy(apisrs_original)
    srs_w_p = SimpleRandomSample(apisrs, popsize=:fpc, probs=fill(0.3, size(apisrs_original, 1)), ignorefpc=true)
    @test srs_w_p.data.probs == 1 ./ srs_w_p.data.weights
    ### ingorefpc = true with probs given
    apisrs = copy(apisrs_original)
    srs = SimpleRandomSample(apisrs, ignorefpc=true, probs=:derived_probs)
    @test srs.data.probs == 1 ./ srs.data.weights
    ##############################
    ### probs as vector declared on-the-fly
    apisrs = copy(apisrs_original)
    srs_prob = SimpleRandomSample(apisrs; probs=1 ./ apisrs.pw)
    @test srs_prob.data.weights[1] == 30.97
    @test srs_prob.data.weights == 1 ./ srs_prob.data.probs
end

@testset "StratifiedSample" begin
    ### StratifiedSample tests
    # Load API datasets
    apistrat_original = load_data("apistrat")
    apistrat_original[!, :derived_probs] = 1 ./ apistrat_original.pw
    apistrat_original[!, :derived_sampsize] = apistrat_original.fpc ./ apistrat_original.pw
    ##############################
    ### Valid type checking tests
    apistrat = copy(apistrat_original)
    @test_throws TypeError StratifiedSample(apistrat,:stype; popsize=-2.83, ignorefpc=true)
    @test_throws TypeError StratifiedSample(apistrat,:stype; sampsize=-300)
    @test_throws TypeError StratifiedSample(apistrat,:stype; sampsize=-2.8, ignorefpc=true)
    @test_throws TypeError StratifiedSample(apistrat,:stype; weights=50)
    @test_throws TypeError StratifiedSample(apistrat,:stype; probs=1)
    ##############################
    ### weights as Symbol
    apistrat = copy(apistrat_original)
    strat_wt = StratifiedSample(apistrat, :stype; weights=:pw)
    @test strat_wt.data.probs == 1 ./ strat_wt.data.weights
    ### probs as Symbol
    apistrat = copy(apistrat_original)
    strat_probs = StratifiedSample(apistrat, :stype; probs=:derived_probs)
    @test strat_probs.data.probs == 1 ./ strat_probs.data.weights
    ### weights as Vector{<:Real}
    apistrat = copy(apistrat_original)
    strat_wt = StratifiedSample(apistrat, :stype; weights=apistrat.pw)
    @test strat_wt.data.probs == 1 ./ strat_wt.data.weights
    ### probs as Vector{<:Real}
    apistrat = copy(apistrat_original)
    strat_probs = StratifiedSample(apistrat, :stype; probs=apistrat.derived_probs)
    @test strat_probs.data.probs == 1 ./ strat_probs.data.weights
    ##############################
    ### popsize as Symbol
    apistrat = copy(apistrat_original)
    strat_pop = StratifiedSample(apistrat, :stype; popsize=:fpc)
    @test strat_pop.data.probs == 1 ./ strat_pop.data.weights
    ### popsize given as Vector (should give error for now, not implemented Vector input directly for popsize)
    apistrat = copy(apistrat_original)
    @test_throws TypeError StratifiedSample(apistrat,:stype; popsize=apistrat.fpc)
    ##############################
    ### sampsize given as Symbol
    apistrat = copy(apistrat_original)
    strat_sampsize_sym = StratifiedSample(apistrat,:stype; sampsize=:derived_sampsize, weights=:pw)
    @test strat_sampsize_sym.data.weights == 1 ./ strat_sampsize_sym.data.probs # weights should be inverse of probs
    ### sampsize given as symbol without weights or probs, and popsize not given - raise error
    apistrat = copy(apistrat_original)
    @test_throws ErrorException StratifiedSample(apistrat,:stype; sampsize=:derived_sampsize)
    ##############################
    ### both weights and probs given
    # If weights given, probs is superfluous
    apistrat = copy(apistrat_original)
    strat_weights_probs = StratifiedSample(apistrat,:stype; weights=:pw, probs=:derived_probs)
    strat_weights_probs = StratifiedSample(apistrat,:stype; weights=:pw, probs=:pw)
    ##############################
    ### ignorefpc test (Modify if ignorefpc changed)
    apistrat = copy(apistrat_original)
    strat_ignorefpc=StratifiedSample(apistrat,:stype; popsize=:fpc, ignorefpc=true)
    @test strat_ignorefpc.data.probs == 1 ./ strat_ignorefpc.data.weights
    ##############################
    # For now, no sum checks on probs and weights for StratifiedSample (unlike SRS)
    apistrat = copy(apistrat_original)
    strat_probs1 = StratifiedSample(apistrat, :stype; probs=fill(0.3, size(apistrat, 1)))
    @test strat_probs1.data.probs == 1 ./ strat_probs1.data.weights
    ##############################
    #should throw error because sampsize > popsize
    apistrat = copy(apistrat_original)
    @test_throws ErrorException StratifiedSample(apistrat, :stype; popsize= :pw, sampsize=:fpc) 
end

@testset "OneStageClusterSample" begin
    # Load API datasets
    apiclus1_original = load_data("apiclus1")
    apiclus1_original[!, :pw] = fill(757/15,(size(apiclus1_original,1),)) # Correct api mistake for pw column
    ##############################
    # one-stage cluster sample
    apiclus1 = copy(apiclus1_original)
    dclus1 = OneStageClusterSample(apiclus1, :dnum, :fpc)
    @test dclus1.data[!,:weights] ≈ fill(50.4667,size(apiclus1,1)) atol = 1e-3
    @test dclus1.data[!,dclus1.sampsize] ≈ fill(15,size(apiclus1,1))
    @test dclus1.data[!,:allprobs] ≈ dclus1.data[!,:probs] atol = 1e-4
end

@testset "SingleStageSurveyDesign" begin
    # Load API datasets
    yrbs_original = load_data("yrbs")
    nhanes_original = load_data("nhanes")
    ##############################
    # NHANES
    nhanes = copy(nhanes_original)
    dnhanes = SingleStageSurveyDesign(nhanes; cluster = :SDMVPSU, strata=:SDMVSTRA, weights=:WTMEC2YR)
    ##############################
    # YRBS
    yrbs = copy(yrbs_original)
    dyrbs = SingleStageSurveyDesign(yrbs; cluster = :psu, strata=:stratum, weights=:weight)
end

# @testset "ClusterSample" begin
#     # # Load API datasets
#     # apiclus1_original = load_data("apiclus1")
#     # apiclus1_original[!, :pw] = fill(757/15,(size(apiclus1_original,1),)) # Correct api mistake for pw column
#     # apiclus2_original = load_data("apiclus2")
#     ##############################
#     ### TODO when they are implemented
#     # one-stage cluster sample
#     # apiclus1 = copy(apiclus1_original)
#     # dclus2 = ClusterSample(apiclus1, :dnum, :fpc)
#     # # two-stage cluster sample
#     # dclus2 = ClusterSample(apiclus2, [:dnum,:snum], [:fpc1,:fpc2])
#     # # two-stage `with replacement'
#     # dclus2wr = ClusterSample(apiclus2, [:dnum,:snum]; weights=:pw)
# end
# @testset "mu284" begin
#     ##############################
#     mu284_original = load_data("mu284")
#     mu284 = copy(mu284_original)
#     dmu284 = SingleStageSurveyDesign(mu284; cluster = :psu, strata=:stratum, weights=:weight)
# end