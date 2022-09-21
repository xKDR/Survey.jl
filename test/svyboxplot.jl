@testset "svyboxplot.jl" begin
    # StratifiedSample
    apisrs = load_data("apisrs")
    srs = SimpleRandomSample(apisrs, popsize = apisrs.fpc)
    # srs = SimpleRandomSample(apisrs) 
    bp = svyboxplot(srs, :stype, :enroll; weights = :pw)

    @test bp.grid[1].entries[1].positional[2] == srs.data[!, :enroll]
    @test bp.grid[1].entries[1].named[:weights] == srs.data[!, :pw]

    # # StratifiedSample
    # apistrat = load_data("apistrat")
    # strat = StratifiedSample(apistrat, apistrat.stype)
    # bp = svyboxplot(strat, :stype, :enroll; weights = :pw)

    # @test bp.grid[1].entries[1].positional[2] == strat.data[!, :enroll]
    # @test bp.grid[1].entries[1].named[:weights] == strat.data[!, :pw]
end
