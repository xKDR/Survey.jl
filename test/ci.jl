@testset "ci.jl" begin
    mean(:api00, dclus1_boot, "normal")
    mean(:api00, dclus1_boot, ci_type="normal", alpha = 0.1)
    mean(:api00, dclus1_boot, ci_type="normal", alpha = 0.15)
    mean(:api00, dclus1_boot, ci_type="margin")
    mean(:api00, dclus1_boot, ci_type="margin",margin=3.0) # 3 - sigma
    mean(:api00, dclus1_boot, ci_type="margin",margin=6.0) # Six-sigma
    mean(:api00, dclus1_boot)
    mean([:api00, :enroll], dclus1_boot, ci_type="normal", alpha = 0.1)
end