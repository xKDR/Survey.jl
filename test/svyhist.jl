@testset "svyhist.jl" begin
    @test Survey.sturges(10) == 5
    @test Survey.sturges([1, 2, 5, 10, 15, 17, 20]) == 4

    # SimpleRandomSample
    apisrs = load_data("apisrs")
    srs = SimpleRandomSample(apisrs,popsize=:fpc)

    h = svyhist(srs, :enroll)
    @test h.grid[1].entries[1].positional[2] |> length == 21

    h = svyhist(srs, :enroll, 9)
    @test h.grid[1].entries[1].positional[2] |> length == 11

    h = svyhist(srs, :enroll, Survey.sturges)
    @test h.grid[1].entries[1].positional[2] |> length == 11

    h = svyhist(srs, :enroll, [0, 1000, 2000, 3000])
    @test h.grid[1].entries[1].positional[2] |> length == 3

    # StratifiedSample
end
