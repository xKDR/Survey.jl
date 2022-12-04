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
    ## Add tests
end

@testset "mean_svyby_SimpleRandomSample" begin
    ## Add tests
end

@testset "mean_svyby_Stratified" begin
    ## Add tests
end


