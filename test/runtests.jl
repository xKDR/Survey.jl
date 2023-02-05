using Survey
using Test
using CategoricalArrays

const STAT_TOL = 1e-5
const SE_TOL = 1e-1

# Simple random sample
apisrs = load_data("apisrs") # Load API dataset
srs = SurveyDesign(apisrs, weights = :pw) 
bsrs = srs |> bootweights # Create replicate design
# Stratified sample
apistrat = load_data("apistrat") # Load API dataset
dstrat = SurveyDesign(apistrat, strata = :stype, weights = :pw) # Create SurveyDesign
bstrat = dstrat |> bootweights # Create replicate design

# One-stage cluster sample
apiclus1 = load_data("apiclus1") # Load API dataset
apiclus1[!, :pw] = fill(757/15,(size(apiclus1,1),)) # Correct api mistake for pw column
dclus1 = SurveyDesign(apiclus1; clusters =  :dnum, weights = :pw) # Create SurveyDesign
dclus1_boot = dclus1 |> bootweights # Create replicate design

@testset "Survey.jl" begin
    @test size(load_data("apiclus1")) == (183, 40)
    @test size(load_data("apiclus2")) == (126, 41)
    @test size(load_data("apipop"))   == ((6194, 38))
end

include("SurveyDesign.jl")
include("total.jl")
include("quantile.jl")
include("mean.jl")
include("plot.jl")
include("hist.jl")
include("boxplot.jl")
include("ratio.jl")
include("show.jl")
include("ci.jl")