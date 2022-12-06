@testset "quantile_SimpleRandomSample" begin
    ##### SimpleRandomSample tests
    # Load API datasets
    apisrs_original = load_data("apisrs")
    apisrs_original[!, :derived_probs] = 1 ./ apisrs_original.pw
    apisrs_original[!, :derived_sampsize] = fill(200.0, size(apisrs_original, 1))
    ##############################
    ### weights or probs as Symbol
    apisrs = copy(apisrs_original)
    srs_design = SimpleRandomSample(apisrs,popsize=:fpc)
end

@testset "quantile_Stratified" begin
    ## Add tests
end

@testset "quantile_by_SimpleRandomSample" begin
    ## Add tests
end

@testset "quantile_by_Stratified" begin
    ## Add tests
end