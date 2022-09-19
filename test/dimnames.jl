@testset "dimnames.jl" begin
    ########### Simple random sampling tests
    apisrs = load_data("apisrs")
    # make a copy to not modify the original dataset
    apisrs_copy = copy(apisrs)
    srs_new = SimpleRandomSample(apisrs_copy,ignorefpc = true)
    # make a new copy to use for the old design
    apisrs_copy = copy(apisrs)
    srs_old = svydesign(id = :1, data = apisrs)
    # `dim`
    @test dim(srs_new)[1] == dim(srs_old)[1]
    @test dim(srs_new)[2] == 42
    @test dim(srs_old)[2] == 45
    # `colnames`
    @test length(colnames(srs_new)) == dim(srs_new)[2]
    @test length(colnames(srs_old)) == dim(srs_old)[2]
    # `dimnames`
    @test length(dimnames(srs_new)[1]) == parse(Int, last(dimnames(srs_new)[1]))
    @test dimnames(srs_new)[2] == colnames(srs_new)
    @test length(dimnames(srs_old)[1]) == parse(Int, last(dimnames(srs_old)[1]))
    @test dimnames(srs_old)[2] == colnames(srs_old)

    ########## Stratified sampling tests
    # apistrat = load_data("apistrat")
    # # make a copy to not modify the original dataset
    # apistrat_copy = copy(apistrat)
    # strat_new = StratifiedSample(apistrat_copy, apistrat_copy.stype)
    # # make a new copy to use for the old design
    # apistrat_copy = copy(apistrat)
    # strat_old = svydesign(id = :1, data = apistrat_copy, strata = :stype)
    # # `dim`
    # @test dim(strat_new)[1] == dim(strat_old)[1]
    # @test dim(strat_new)[2] == 45
    # @test dim(strat_old)[2] == 45
    # # `colnames`
    # @test length(colnames(strat_new)) == dim(strat_new)[2]
    # @test length(colnames(strat_old)) == dim(strat_old)[2]
    # # `dimnames`
    # @test length(dimnames(strat_new)[1]) == parse(Int, last(dimnames(strat_new)[1]))
    # @test dimnames(strat_new)[2] == colnames(strat_new)
    # @test length(dimnames(strat_old)[1]) == parse(Int, last(dimnames(strat_old)[1]))
    # @test dimnames(strat_old)[2] == colnames(strat_old)
end
