@testset "svyplot.jl" begin
    # SimpleRandomSample
    apisrs = load_data("apisrs")
    srs = SimpleRandomSample(apisrs)
    s = svyplot(srs, :api99, :api00)

    @test s.grid[1].entries[1].named[:markersize] == srs.data.weights
    @test s.grid[1].entries[1].positional[1] == srs.data.api99
    @test s.grid[1].entries[1].positional[2] == srs.data.api00

    # StratifiedSample
    apistrat = load_data("apistrat")
    dstrat = svydesign(data = apistrat, id = :1, strata = :stype, weights = :pw, fpc = :fpc)
    s_strat = svyplot(dstrat, :api99, :api00)

    @test s_strat.grid[1].entries[1].named[:markersize] == dstrat.variables.weights
    @test s_strat.grid[1].entries[1].positional[1] == dstrat.variables.api99
    @test s_strat.grid[1].entries[1].positional[2] == dstrat.variables.api00
end
