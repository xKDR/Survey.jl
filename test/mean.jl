@testset "mean_SimpleRandomSample" begin
    ##### SimpleRandomSample tests
    # Load API datasets
    apisrs_original = load_data("apisrs")
    apisrs_original[!, :derived_probs] = 1 ./ apisrs_original.pw
    apisrs_original[!, :derived_sampsize] = fill(200.0, size(apisrs_original, 1))
    ##############################
    ### Basic functionality
    apisrs = copy(apisrs_original)
    srs = SurveyDesign(apisrs, weights = :pw) |> bootweights 

    @test mean(:api00, srs).mean[1] ≈ 656.585 atol = 1e-4
    @test mean(:api00, srs).SE[1] ≈ 9.402772170880636 atol = 1e-1
    @test mean(:enroll, srs).mean[1] ≈ 584.61 atol = 1e-4
    @test mean(:enroll, srs).SE[1] ≈ 27.821214737089324 atol = 1
    ##############################
    ### Vector of Symbols
    mean_vec_sym = mean([:api00,:enroll], srs)
    @test mean_vec_sym.mean[1] ≈ 656.585 atol = 1e-4
    @test mean_vec_sym.SE[1] ≈ 9.3065 rtol = 1e-1
    @test mean_vec_sym.mean[2] ≈ 584.61 atol = 1e-4
    @test mean_vec_sym.SE[2] ≈ 28.1048 rtol = 1e-1
    ##############################
    ### Categorical Array - estimating proportions
    # apisrs_categ = copy(apisrs_original)
    # apisrs_categ.stype = CategoricalArray(apisrs_categ.stype) # Convert a column to CategoricalArray
    # srs_design_categ = SurveyDesign(apisrs_categ, weights = :pw)
    #>>>>>>>>> complete this suite
    # mean_categ = mean(:stype,srs_design_categ)
    # complete this 
end

@testset "mean_Stratified" begin
    apistrat_original = load_data("apistrat")
    apistrat = copy(apistrat_original)
    strat = SurveyDesign(apistrat, strata = :stype, weights = :pw) |> bootweights
    mean_strat = mean(:api00, strat)
    @test mean_strat.mean[1] ≈ 662.29 rtol = 1e-1
    @test mean_strat.SE[1] ≈ 9.48296 atol = 1e-1
end

@testset "mean_svyby_SimpleRandomSample" begin
    apisrs_original = load_data("apisrs")
    apisrs = copy(apisrs_original)
    srs = SurveyDesign(apisrs; popsize = :fpc) |> bootweights
    mean_symb_srs = mean(:api00, :stype, srs)
    @test mean_symb_srs.mean[1] ≈ 605.36 rtol = 1e-1
    @test mean_symb_srs.mean[2] ≈ 666.141 rtol = 1e-1
    @test mean_symb_srs.mean[3] ≈ 654.273 rtol = 1e-1
    @test mean_symb_srs.SE[1] ≈ 22.6718 rtol = 1e-1
    @test mean_symb_srs.SE[2] ≈ 11.35390 rtol = 1e-1
    @test mean_symb_srs.SE[3] ≈ 22.3298 rtol = 1e-1
end

@testset "mean_svyby_Stratified" begin
    apistrat_original = load_data("apistrat")
    apistrat = copy(apistrat_original)
    strat = SurveyDesign(apistrat; strata = :stype, weights = :pw) |> bootweights
    mean_strat_symb = mean(:api00, :stype, strat)
    @test mean_strat_symb.mean[1] ≈ 674.43 rtol = 1e-1
    @test mean_strat_symb.mean[2] ≈ 636.6 rtol = 1e-1
    @test mean_strat_symb.mean[3] ≈ 625.82 rtol = 1e-1
    @test mean_strat_symb.SE[1] ≈ 12.4398 rtol = 1e-1
    @test mean_strat_symb.SE[2] ≈ 16.5628 rtol = 1e-1
    @test mean_strat_symb.SE[3] ≈ 15.42320 rtol = 1e-1
end

@testset "mean_OneStageCluster" begin

    apiclus1_original = load_data("apiclus1")
    apiclus1_original[!, :pw] = fill(757/15,(size(apiclus1_original,1),)) # Correct api mistake for pw column
    ##############################
    # one-stage cluster sample
    apiclus1 = copy(apiclus1_original)
    dclus1 = SurveyDesign(apiclus1; clusters =  :dnum, weights = :pw) |> bootweights 
    @test mean(:api00, dclus1).mean[1] ≈ 644.17 rtol = 1e-1
    @test mean(:api00, dclus1).SE[1] ≈  23.291 rtol = 1e-1 # without fpc as it hasn't been figured out for bootstrap. 

    mn = mean(:api00, :cname, dclus1)
    @test size(mn)[1] == apiclus1.cname |> unique |> length
    @test filter(:cname => ==("Los Angeles"), mn).mean[1] ≈ 647.2667 rtol = STAT_TOL
    @test filter(:cname => ==("Los Angeles"), mn).SE[1] ≈ 41.537132 rtol = 1 # tolerance is too large
    @test filter(:cname => ==("Santa Clara"), mn).mean[1] ≈ 732.0769 rtol = STAT_TOL
    @test filter(:cname => ==("Santa Clara"), mn).SE[1] ≈ 54.215099 rtol = SE_TOL
end
