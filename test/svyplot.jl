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
    strat = StratifiedSample(apistrat, apistrat.stype; weights = apistrat.pw)
    dstrat = svydesign(data = apistrat, id = :1, strata = :stype, weights = :pw, fpc = :fpc)
    s_strat_new = svyplot(strat, :api99, :api00)
    s_strat_old = svyplot(dstrat, :api99, :api00)

    @test s_strat_new.grid[1].entries[1].named[:markersize] == strat.data.weights
    @test s_strat_new.grid[1].entries[1].positional[1] == strat.data.api99
    @test s_strat_new.grid[1].entries[1].positional[2] == strat.data.api00
    @test s_strat_old.grid[1].entries[1].named[:markersize] == dstrat.variables.weights
    @test s_strat_old.grid[1].entries[1].positional[1] == dstrat.variables.api99
    @test s_strat_old.grid[1].entries[1].positional[2] == dstrat.variables.api00
end
