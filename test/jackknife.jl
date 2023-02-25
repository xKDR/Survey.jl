@testset "jackknife" begin
    dclus1_jack = dclus1 |> jackknifeweights
    dclus1_jk1 = dclus1 |> jk1weights # Create replicate design
end