using Survey
using Test

@testset "svyhist.jl" begin
	apistrat = load_data("apistrat")
	dstrat = svydesign(data = apistrat, id = :1, strata = :stype, weights = :pw, fpc = :fpc)

	@test Survey.sturges(10) == 5
	@test Survey.sturges([1, 2, 5, 10, 15, 17, 20]) == 4

	h = svyhist(dstrat, :enroll)
	@test h.grid[1].entries[1].positional[2] |> length == 16

	h = svyhist(dstrat, :enroll, 9)
	@test h.grid[1].entries[1].positional[2] |> length == 7

	h = svyhist(dstrat, :enroll, Survey.sturges)
	@test h.grid[1].entries[1].positional[2] |> length == 7

	h = svyhist(dstrat, :enroll, [0, 1000, 2000, 3000])
	@test h.grid[1].entries[1].positional[2] |> length == 3
end
