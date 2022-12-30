@testset "mean_SimpleRandomSample" begin
    ##### SimpleRandomSample tests
    # Load API datasets
    apisrs_original = load_data("apisrs")
    apisrs_original[!, :derived_probs] = 1 ./ apisrs_original.pw
    apisrs_original[!, :derived_sampsize] = fill(200.0, size(apisrs_original, 1))
    ##############################
    ### Basic functionality
    apisrs = copy(apisrs_original)
    srs = SimpleRandomSample(apisrs, popsize = :fpc)
    @test mean(:api00, srs).mean[1] ≈ 656.585 atol = 1e-4
    @test mean(:api00, srs).SE[1] ≈ 9.249722039282807 atol = 1e-4
    @test mean(:enroll, srs).mean[1] ≈ 584.61 atol = 1e-4
    @test mean(:enroll, srs).SE[1] ≈ 27.36836524766856 atol = 1e-4
    # ignorefpc = true
    apisrs = copy(apisrs_original)
    srs = SimpleRandomSample(apisrs, popsize=:fpc,ignorefpc = true)
    @test mean(:api00, srs).mean[1] ≈ 656.585 atol = 1e-4
    @test mean(:api00, srs).SE[1] ≈ 9.402772170880636 atol = 1e-4
    @test mean(:enroll, srs).mean[1] ≈ 584.61 atol = 1e-4
    @test mean(:enroll, srs).SE[1] ≈ 27.821214737089324 atol = 1e-4
    ##############################
    ### Vector of Symbols
    apisrs = copy(apisrs_original)
    srs = SimpleRandomSample(apisrs, popsize = :fpc)
    mean_vec_sym = mean([:api00,:enroll], srs)
    @test mean_vec_sym.mean[1] ≈ 656.585 atol = 1e-4
    @test mean_vec_sym.SE[1] ≈ 9.249722039282807 atol = 1e-4
    @test mean_vec_sym.mean[2] ≈ 584.61 atol = 1e-4
    @test mean_vec_sym.SE[2] ≈ 27.36836524766856 atol = 1e-4
    ##############################
    ### Categorical Array - estimating proportions
    apisrs_categ = copy(apisrs_original)
    apisrs_categ.stype = CategoricalArray(apisrs_categ.stype) # Convert a column to CategoricalArray
    srs_design_categ = SimpleRandomSample(apisrs_categ, popsize = :fpc)
    #>>>>>>>>> complete this suite
    mean_categ = mean(:stype,srs_design_categ)
    # complete this 
end

@testset "mean_Stratified" begin
    apistrat_original = load_data("apistrat")
    apistrat = copy(apistrat_original)
    strat = StratifiedSample(apistrat, :stype; popsize = :fpc)
    mean_strat = mean(:api00, strat)
    @test mean_strat.mean[1] ≈ 662.287 atol = 1e-2
    @test mean_strat.SE[1] ≈ 9.40894 atol = 1e-2
end

@testset "mean_svyby_SimpleRandomSample" begin
    apisrs_original = load_data("apisrs")
    apisrs = copy(apisrs_original)
    srs = SimpleRandomSample(apisrs, popsize = :fpc)
    mean_symb_srs = mean(:api00, :stype, srs)
    @test mean_symb_srs.mean[1] ≈ 605.36 atol = 1e-2
    @test mean_symb_srs.mean[2] ≈ 666.141 atol = 1e-2
    @test mean_symb_srs.mean[3] ≈ 654.273 atol = 1e-2
    @test mean_symb_srs.SE[1] ≈ 21.9266 atol = 1e-2
    @test mean_symb_srs.SE[2] ≈ 11.1935 atol = 1e-2
    @test mean_symb_srs.SE[3] ≈ 21.8261 atol = 1e-2
end

@testset "mean_svyby_Stratified" begin
    apistrat_original = load_data("apistrat")
    apistrat = copy(apistrat_original)
    strat = StratifiedSample(apistrat, :stype; popsize = :fpc)
    mean_strat_symb = mean(:api00,:stype, strat)
    @test mean_strat_symb.mean[1] ≈ 674.43 atol = 1e-2
    @test mean_strat_symb.mean[2] ≈ 636.6 atol = 1e-2
    @test mean_strat_symb.mean[3] ≈ 625.82 atol = 1e-2
    @test mean_strat_symb.SE[1] ≈ 12.3825 atol = 1e-2
    @test mean_strat_symb.SE[2] ≈ 16.2147 atol = 1e-2
    @test mean_strat_symb.SE[3] ≈ 14.9371 atol = 1e-2
end

@testset "mean_OneStageCluster" begin

    apiclus1_original = load_data("apiclus1")
    apiclus1_original[!, :pw] = fill(757/15,(size(apiclus1_original,1),)) # Correct api mistake for pw column
    ##############################
    # one-stage cluster sample
    apiclus1 = copy(apiclus1_original)
    dclus1 = SurveyDesign(apiclus1, :dnum, :fpc)

    @test mean(:api00,dclus1, Bootstrap()).mean[1] ≈ 644.17 atol = 1
    @test mean(:api00,dclus1, Bootstrap(replicates = 10000)).SE[1] ≈ 23.779 atol = 0.5 # without fpc as it hasn't been figured out for bootstrap. 
end
