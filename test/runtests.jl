using Survey
using Test

@testset "Survey.jl" begin
    apiclus1 = load_data("apiclus1")
    @test size(apiclus1) == (183, 40)
    @test size(load_data("apiclus2")) == (126, 41)
    @test size(load_data("apipop"))   == ((6194, 38))
end

include("SurveyDesign.jl")
include("total.jl")
include("quantile.jl")
include("mean.jl")
include("dimnames.jl")
include("plot.jl")
include("hist.jl")
include("boxplot.jl")