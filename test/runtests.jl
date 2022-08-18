using Survey
using Test

@testset "Survey.jl" begin
    apiclus1 = load_data("apiclus1")
    @test size(apiclus1) == (183, 40)
    @test size(load_data("apiclus2")) == (126, 41)
    @test size(load_data("apipop"))   == ((6194, 38))
    dclus1 = svydesign(id=:1, strata=:stype, weights=:pw, data = apiclus1, fpc=:fpc)
	@test dclus1.variables.strata[1] == "H"
    @test length(dclus1.variables.probs) == 183
    @test dclus1.id == 1
    api00_by_cname = svyby(:api00, :cname, dclus1, svymean).mean
    @test api00_by_cname ≈ [669.0000000000001, 472.00000000000006, 452.5, 647.2666666666668, 623.25, 519.25, 710.5625000000001, 709.5555555555557, 659.4363636363635, 551.1891891891892, 732.0769230769226]
    api00_by_cname_meals = svyby(:api00, [:cname, :meals], dclus1, svymean)
    @test api00_by_cname_meals[1,3] ≈ 608.0
end

include("SurveyDesign.jl")
include("svyglm.jl")
include("svyhist.jl")
include("svyplot.jl")
include("dimnames.jl")
include("svyplot.jl")
include("svyboxplot.jl")
