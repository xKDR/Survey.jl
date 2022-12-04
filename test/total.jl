@testset "total_SimpleRandomSample" begin
    ##### SimpleRandomSample tests
    # Load API datasets
    apisrs_original = load_data("apisrs")
    apisrs_original[!, :derived_probs] = 1 ./ apisrs_original.pw
    apisrs_original[!, :derived_sampsize] = fill(200.0, size(apisrs_original, 1))
    ##############################
    ### Basic functionality
    apisrs = copy(apisrs_original)
    srs = SimpleRandomSample(apisrs, popsize = :fpc)
    tot = total(:api00, srs)
    @test tot.total[1] ≈ 4.06688749e6 atol = 1e-4
    @test tot.SE[1] ≈ 57292.7783113177 atol = 1e-4
    # TODO: ignorefpc tests dont actaully work??
    # # without fpc
    srs_ignorefpc = SimpleRandomSample(apisrs, popsize = :fpc, ignorefpc = true)
    tot = total(:api00, srs_ignorefpc)
    # @test tot.total[1] ≈ XXX
    # @test tot.se_total[1] ≈ XXX
end

@testset "total_Stratified" begin
    ## Add tests
end

@testset "total_svyby_SimpleRandomSample" begin
    ## Add tests
end

@testset "total_svyby_Stratified" begin
    ## Add tests
end