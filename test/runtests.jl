using Survey
using Test

@testset "Survey.jl" begin
    apiclus1 = load_data("apiclus1")
    @test size(apiclus1) == (183, 40)
    @test size(load_data("apiclus2")) == (126, 41)
    @test size(load_data("apipop"))   == ((6194, 38))
    # WRONG DESIGN FOR CLUSTER SAMPLE
    dclus1 = svydesign(id=:1, strata=:stype, weights=:pw, data = apiclus1, fpc=:fpc)
	@test dclus1.variables.strata[1] == "H"
    @test length(dclus1.variables.probs) == 183
    @test dclus1.id == 1
end

include("SurveyDesign.jl")
include("svytotal.jl")
include("svyquantile.jl")
include("svymean.jl")
include("dimnames.jl")
include("svyglm.jl")
include("svyplot.jl")
include("svyhist.jl")
include("svyboxplot.jl")
