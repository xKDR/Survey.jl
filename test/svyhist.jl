@testset "svyhist.jl" begin
    @test Survey.sturges(10) == 5
    @test Survey.sturges([1, 2, 5, 10, 15, 17, 20]) == 4

    # SimpleRandomSample
    apisrs = load_data("apisrs")
    srs = SimpleRandomSample(apisrs)

    h = svyhist(srs, :enroll)
    @test h.grid[1].entries[1].positional[2] |> length == 21

    h = svyhist(srs, :enroll, 9)
    @test h.grid[1].entries[1].positional[2] |> length == 11

    h = svyhist(srs, :enroll, Survey.sturges)
    @test h.grid[1].entries[1].positional[2] |> length == 11

    h = svyhist(srs, :enroll, [0, 1000, 2000, 3000])
    @test h.grid[1].entries[1].positional[2] |> length == 3

    # StratifiedSample
    apistrat = load_data("apistrat")
    dstrat = svydesign(data = apistrat, id = :1, strata = :stype, weights = :pw, fpc = :fpc)
    apistrat = load_data("apistrat")
    strat = StratifiedSample(apistrat, apistrat.stype)

    h = svyhist(strat, :enroll)
    @test h.grid[1].entries[1].positional[2] |> length == 16
    h = svyhist(dstrat, :enroll)
    @test h.grid[1].entries[1].positional[2] |> length == 16

    h = svyhist(strat, :enroll, 9)
    @test h.grid[1].entries[1].positional[2] |> length == 7
    h = svyhist(dstrat, :enroll, 9)
    @test h.grid[1].entries[1].positional[2] |> length == 7

    h = svyhist(strat, :enroll, Survey.sturges)
    @test h.grid[1].entries[1].positional[2] |> length == 7
    h = svyhist(dstrat, :enroll, Survey.sturges)
    @test h.grid[1].entries[1].positional[2] |> length == 7

    h = svyhist(strat, :enroll, [0, 1000, 2000, 3000])
    @test h.grid[1].entries[1].positional[2] |> length == 3
    h = svyhist(dstrat, :enroll, [0, 1000, 2000, 3000])
    @test h.grid[1].entries[1].positional[2] |> length == 3
end
