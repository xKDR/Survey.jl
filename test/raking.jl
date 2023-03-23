@testset "ratio.jl" begin
    poptypes = [4421,755,1018] # taken by grouping by over the survey
    popschwide = [1072,5122]
    #### Check how weights changed before and after `raking`
    #@show dclus1.data[!,dclus1.weights]
    raking(dclus1, :stype, :schwide, poptypes, popschwide, [100, 2] )
    #@show dclus1.data[!,dclus1.weights]
end