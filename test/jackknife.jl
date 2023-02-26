@testset "jackknife" begin
    dclus1_jack = dnhanes |> jackknifeweights
    dclus1_jk1 = dclus1 |> jk1weights # Create replicate design
end
dclus1_jk1 = dclus1 |> jk1weights
dclus1_jack = dnhanes |> jackknifeweights