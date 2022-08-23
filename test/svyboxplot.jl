@testset "svyplot.jl" begin
    # StratifiedSample
    apisrs = load_data("apisrs")
    srs = SimpleRandomSample(apisrs)
    bp = svyboxplot(srs, :stype, :enroll; weights = :pw)

    @test bp.grid[1].entries[1].positional[2] == srs.data[!, :enroll]
    @test bp.grid[1].entries[1].named[:weights] == srs.data[!, :pw]

    # StratifiedSample
    apistrat = load_data("apistrat")
    dstrat = svydesign(data = apistrat, id = :1, strata = :stype, weights = :pw, fpc = :fpc)
    bp = svyboxplot(dstrat, :stype, :enroll; weights = :pw)

    @test bp.grid[1].entries[1].positional[2] == dstrat.variables[!, :enroll]
    @test bp.grid[1].entries[1].named[:weights] == dstrat.variables[!, :pw]
end
