@testset "ratio.jl" begin
    apiclus1 = load_data("apiclus1") # Load API dataset
    apiclus1[!, :pw] = fill(757/15,(size(apiclus1,1),)) # Correct api mistake for pw column
    apiclus1.schwide = apiclus1[!,"sch.wide"]
    dclus1 = SurveyDesign(apiclus1; clusters =  :dnum, weights = :pw) 
    poptypes = [4421,755,1018]
    popschwide = [1072,5122]
    
    raking(dclus1,:stype, :schwide,poptypes,popschwide, [100, 2] )
    #@show dclus1.data[!,dclus1.weights]
end