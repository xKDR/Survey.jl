using GLM, Statistics, DataFrames

# Load datasets
apisrs = load_data("apisrs")
apistrat = load_data("apistrat")
apiclus1 = load_data("apiclus1")
apiclus2 = load_data("apiclus2")

# Create survey designs
designs = [
    SurveyDesign(apisrs),
    SurveyDesign(apistrat; strata=:stype, weights=:pw),
    SurveyDesign(apiclus1; clusters=:dnum, weights=:pw),
    SurveyDesign(apiclus2; clusters=[:dnum, :snum], weights=:pw)
]

# Set test tolerance
tol = 1

@testset "Linear GLM on different survey designs" begin
    for svydesign in designs
        glm_model = glm(@formula(api00 ~ api99), svydesign.data, Normal())
        repdesign = bootweights(svydesign; replicates = 1000)
        svyglm_result = svyglm(@formula(api00 ~ api99), repdesign, Normal())

        @test svyglm_result.Coefficients ≈ coef(glm_model) rtol=tol
        @test svyglm_result.SE ≈ stderror(glm_model) rtol=tol
    end
end