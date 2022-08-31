using Survey
using Test

@testset "Survey.jl" begin
    apiclus1 = load_data("apiclus1")
    @test size(apiclus1) == (183, 40)
    @test size(load_data("apiclus2")) == (126, 41)
    @test size(load_data("apipop"))   == ((6194, 38))
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
