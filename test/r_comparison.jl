# Compare estimates against reference values computed by the R `survey` package.
#
# The reference values live in test/r_reference/*.csv and are regenerated with
#   Rscript test/r_reference/generate_fixtures.R
# The api, scd and nhanes datasets shipped with Survey.jl are identical to the
# ones in the R survey package, so deterministic estimates must agree to
# numerical precision.

using CSV

const R_REFERENCE = joinpath(@__DIR__, "r_reference")
r_fixture(f) = CSV.read(joinpath(R_REFERENCE, f), DataFrame)

const RTOL = 1e-9
# Some reference standard errors are mathematically zero (e.g. proportions of
# the stratification variable itself); both R and Julia then produce values at
# the level of floating-point noise, so an absolute tolerance is needed too.
const ATOL = 1e-10

# The designs used throughout, matching generate_fixtures.R:
#   srs_w      svydesign(id=~1, weights=~pw, data=apisrs)
#   srs_fpc    svydesign(id=~1, fpc=~fpc, data=apisrs)
#   strat_w    svydesign(id=~1, strata=~stype, weights=~pw, data=apistrat)
#   strat_fpc  svydesign(id=~1, strata=~stype, fpc=~fpc, data=apistrat)
#   clus1_w    svydesign(id=~dnum, weights=~pw, data=apiclus1)
#   clus1_fpc  svydesign(id=~dnum, fpc=~fpc, data=apiclus1)
# Designs are rebuilt per testset because some functions (e.g. jackknifeweights)
# modify the wrapped data in place.
function r_designs()
    Dict(
        "srs_w" => SurveyDesign(copy(load_data("apisrs")); weights = :pw),
        "srs_fpc" => SurveyDesign(copy(load_data("apisrs")); popsize = :fpc),
        "strat_w" => SurveyDesign(copy(load_data("apistrat")); strata = :stype, weights = :pw),
        "strat_fpc" => SurveyDesign(copy(load_data("apistrat")); strata = :stype, popsize = :fpc),
        "clus1_w" => SurveyDesign(copy(load_data("apiclus1")); clusters = :dnum, weights = :pw),
        "clus1_fpc" => SurveyDesign(copy(load_data("apiclus1")); clusters = :dnum, popsize = :fpc),
    )
end

@testset "R svymean/svytotal/svyratio (linearized)" begin
    designs = r_designs()
    designs["nhanes"] = SurveyDesign(
        copy(load_data("nhanes"));
        clusters = :SDMVPSU,
        strata = :SDMVSTRA,
        weights = :WTMEC2YR,
    )
    for r in eachrow(r_fixture("est_basic.csv"))
        d = designs[r.design]
        if r.stat == "mean"
            out = mean(Symbol(r.variable), d)
            @test out.mean[1] ≈ r.est rtol = RTOL atol = ATOL
            @test out.SE[1] ≈ r.se rtol = RTOL atol = ATOL
        elseif r.stat == "total"
            out = total(Symbol(r.variable), d)
            @test out.total[1] ≈ r.est rtol = RTOL atol = ATOL
            @test out.SE[1] ≈ r.se rtol = RTOL atol = ATOL
        else # ratio
            out = ratio([:api00, :enroll], d)
            @test out.ratio[1] ≈ r.est rtol = RTOL atol = ATOL
            @test out.SE[1] ≈ r.se rtol = RTOL atol = ATOL
        end
    end
end

@testset "R degf" begin
    designs = r_designs()
    designs["nhanes"] = SurveyDesign(
        copy(load_data("nhanes"));
        clusters = :SDMVPSU,
        strata = :SDMVSTRA,
        weights = :WTMEC2YR,
    )
    for r in eachrow(r_fixture("degf.csv"))
        @test degf(designs[r.design]) == r.degf
    end
end

@testset "R svymean/svytotal on factors (proportions)" begin
    designs = r_designs()
    for r in eachrow(r_fixture("proportions.csv"))
        d = designs[r.design]
        m = mean(Symbol(r.variable), d)
        t = total(Symbol(r.variable), d)
        mrow = m[m.level.==r.level, :]
        trow = t[t.level.==r.level, :]
        @test mrow.mean[1] ≈ r.mean_est rtol = RTOL atol = ATOL
        @test mrow.SE[1] ≈ r.mean_se rtol = RTOL atol = ATOL
        @test trow.total[1] ≈ r.total_est rtol = RTOL atol = ATOL
        @test trow.SE[1] ≈ r.total_se rtol = RTOL atol = ATOL
    end
end

@testset "R svyby (domain estimation, linearized)" begin
    designs = r_designs()
    for r in eachrow(r_fixture("domain.csv"))
        d = designs[r.design]
        by = Symbol(r.by)
        m = mean(:api00, by, d)
        t = total(:api00, by, d)
        mrow = m[m[!, by].==r.domain, :]
        trow = t[t[!, by].==r.domain, :]
        @test mrow.mean[1] ≈ r.mean_est rtol = RTOL atol = ATOL
        @test mrow.SE[1] ≈ r.mean_se rtol = RTOL atol = ATOL
        @test trow.total[1] ≈ r.total_est rtol = RTOL atol = ATOL
        @test trow.SE[1] ≈ r.total_se rtol = RTOL atol = ATOL
    end
end

@testset "R svyvar" begin
    designs = r_designs()
    ref = r_fixture("variance.csv")
    for r in eachrow(ref[ref.design.!="strat_w_jkn", :])
        v = var(:api00, designs[r.design])
        @test v.var[1] ≈ r.est rtol = RTOL atol = ATOL
        @test v.SE[1] ≈ r.se rtol = RTOL atol = ATOL
        s = std(:api00, designs[r.design])
        @test s.std[1] ≈ sqrt(r.est) rtol = RTOL atol = ATOL
    end
    # replicate-weights version against R JKn
    jkn = jackknifeweights(designs["strat_w"])
    v = var(:api00, jkn)
    rj = ref[ref.design.=="strat_w_jkn", :]
    @test v.var[1] ≈ rj.est[1] rtol = RTOL atol = ATOL
    @test v.SE[1] ≈ rj.se[1] rtol = RTOL atol = ATOL
end

@testset "R confint" begin
    designs = r_designs()
    for r in eachrow(r_fixture("confint.csv"))
        d = designs[r.design]
        ci_normal = confint(mean(:api00, d))
        ci_t = confint(mean(:api00, d); dof = degf(d))
        @test ci_normal.ci_lower[1] ≈ r.normal_lower rtol = RTOL atol = ATOL
        @test ci_normal.ci_upper[1] ≈ r.normal_upper rtol = RTOL atol = ATOL
        @test ci_t.ci_lower[1] ≈ r.t_lower rtol = RTOL atol = ATOL
        @test ci_t.ci_upper[1] ≈ r.t_upper rtol = RTOL atol = ATOL
    end
end

@testset "R svytable" begin
    designs = r_designs()
    for (file, dname) in
        [("svytable_strat.csv", "strat_w"), ("svytable_clus1.csv", "clus1_w")]
        tbl = svytable(designs[dname], :stype, :awards)
        for r in eachrow(r_fixture(file))
            row = tbl[(tbl.stype.==r.stype).&(tbl.awards.==r.awards), :]
            @test row.Freq[1] ≈ r.Freq rtol = RTOL atol = ATOL
        end
    end
    tbl = svytable(designs["strat_w"], :stype)
    for r in eachrow(r_fixture("svytable_oneway.csv"))
        @test tbl[tbl.stype.==r.stype, :Freq][1] ≈ r.Freq rtol = RTOL atol = ATOL
    end
end

@testset "R svyttest" begin
    designs = r_designs()
    for r in eachrow(r_fixture("ttest.csv"))
        tt = svyttest(:api00, Symbol("comp.imp"), designs[r.design])
        @test tt.estimate[1] ≈ r.est rtol = RTOL atol = ATOL
        @test tt.t[1] ≈ r.t rtol = RTOL atol = ATOL
        @test tt.df[1] == r.df
        @test tt.p_value[1] ≈ r.p rtol = RTOL atol = ATOL
        @test tt.ci_lower[1] ≈ r.ci_lower rtol = RTOL atol = ATOL
        @test tt.ci_upper[1] ≈ r.ci_upper rtol = RTOL atol = ATOL
    end
end

@testset "R trimWeights" begin
    designs = r_designs()
    trimmed = trimweights(designs["strat_w"]; upper = 40)
    merged = leftjoin(
        DataFrame(snum = trimmed.data.snum, w = trimmed.data[!, trimmed.weights]),
        r_fixture("trimweights_weights.csv"),
        on = :snum,
    )
    @test maximum(abs.(merged.w .- merged.weight)) < 1e-9
    m = mean(:api00, trimmed)
    ref = r_fixture("trimweights_mean.csv")
    @test m.mean[1] ≈ ref.est[1] rtol = RTOL atol = ATOL
    @test m.SE[1] ≈ ref.se[1] rtol = RTOL atol = ATOL
end

@testset "R BRR and Fay (scd)" begin
    scd = load_data("scd")
    scd.w = fill(1.0, nrow(scd))
    dscd = SurveyDesign(copy(scd); clusters = :ambulance, strata = :ESA, weights = :w)
    brr = brrweights(dscd)
    @test brr.replicates == 4
    refw = r_fixture("brr_scd_repweights.csv")
    for rep = 1:4, i = 1:6
        @test brr.data[i, "replicate_$rep"] ≈ refw[i, "replicate_$rep"] atol = 1e-12
    end
    fay = brrweights(dscd; fay_rho = 0.3)
    for r in eachrow(r_fixture("brr_scd_results.csv"))
        v = Symbol(r.variable)
        mb = mean(v, brr)
        tb = total(v, brr)
        mf = mean(v, fay)
        tf = total(v, fay)
        @test mb.mean[1] ≈ r.brr_mean rtol = RTOL atol = ATOL
        @test mb.SE[1] ≈ r.brr_mean_se rtol = RTOL atol = ATOL
        @test tb.total[1] ≈ r.brr_total rtol = RTOL atol = ATOL
        @test tb.SE[1] ≈ r.brr_total_se rtol = RTOL atol = ATOL
        @test mf.mean[1] ≈ r.fay_mean rtol = RTOL atol = ATOL
        @test mf.SE[1] ≈ r.fay_mean_se rtol = RTOL atol = ATOL
        @test tf.total[1] ≈ r.fay_total rtol = RTOL atol = ATOL
        @test tf.SE[1] ≈ r.fay_total_se rtol = RTOL atol = ATOL
    end
end

@testset "R BRR and Fay (synthetic, 7 strata)" begin
    data = r_fixture("brr_synth_data.csv")
    design = SurveyDesign(copy(data); clusters = :psu, strata = :stratum, weights = :w)
    brr = brrweights(design)
    fay = brrweights(design; fay_rho = 0.5)
    @test brr.replicates == 8
    ref = r_fixture("brr_synth_results.csv")
    mb = mean(:y, brr)
    tb = total(:y, brr)
    mf = mean(:y, fay)
    tf = total(:y, fay)
    @test mb.mean[1] ≈ ref.brr_mean[1] rtol = RTOL atol = ATOL
    @test mb.SE[1] ≈ ref.brr_mean_se[1] rtol = RTOL atol = ATOL
    @test tb.total[1] ≈ ref.brr_total[1] rtol = RTOL atol = ATOL
    @test tb.SE[1] ≈ ref.brr_total_se[1] rtol = RTOL atol = ATOL
    @test mf.mean[1] ≈ ref.fay_mean[1] rtol = RTOL atol = ATOL
    @test mf.SE[1] ≈ ref.fay_mean_se[1] rtol = RTOL atol = ATOL
    @test tf.total[1] ≈ ref.fay_total[1] rtol = RTOL atol = ATOL
    @test tf.SE[1] ≈ ref.fay_total_se[1] rtol = RTOL atol = ATOL
end

@testset "R postStratify" begin
    designs = r_designs()
    pop_types = DataFrame(stype = ["E", "H", "M"], Freq = [4421, 755, 1018])
    ps = poststratify(designs["clus1_w"], :stype, pop_types)
    merged = leftjoin(
        DataFrame(snum = ps.data.snum, w = ps.data[!, ps.weights]),
        r_fixture("poststratify_weights.csv"),
        on = :snum,
    )
    @test maximum(abs.(merged.w .- merged.weight)) < 1e-9
    # post-stratified population counts reproduce the known totals
    @test sort(total(:stype, ps).total) ≈ sort(Float64.(pop_types.Freq)) rtol = RTOL atol = ATOL
    ref = r_fixture("poststratify_results.csv")
    @test mean(:api00, ps).mean[1] ≈ ref.lin_mean_est[1] rtol = RTOL atol = ATOL
    # replicate design: SEs match R's post-stratified jackknife
    psjk = poststratify(jackknifeweights(designs["clus1_w"]), :stype, pop_types)
    m = mean(:api00, psjk)
    t = total(:api00, psjk)
    @test m.mean[1] ≈ ref.mean_est[1] rtol = RTOL atol = ATOL
    @test m.SE[1] ≈ ref.mean_se[1] rtol = RTOL atol = ATOL
    @test t.total[1] ≈ ref.total_est[1] rtol = RTOL atol = ATOL
    @test t.SE[1] ≈ ref.total_se[1] rtol = RTOL atol = ATOL
end

@testset "R rake" begin
    designs = r_designs()
    pop_types = DataFrame(stype = ["E", "H", "M"], Freq = [4421, 755, 1018])
    pop_schwide = DataFrame(Symbol("sch.wide") => ["No", "Yes"], :Freq => [1072, 5122])
    margins = [:stype, Symbol("sch.wide")]
    populations = [pop_types, pop_schwide]
    raked = rake(designs["clus1_w"], margins, populations)
    merged = leftjoin(
        DataFrame(snum = raked.data.snum, w = raked.data[!, raked.weights]),
        r_fixture("rake_weights.csv"),
        on = :snum,
    )
    @test maximum(abs.(merged.w .- merged.weight)) < 1e-6
    rkjk = rake(jackknifeweights(r_designs()["clus1_w"]), margins, populations)
    ref = r_fixture("rake_results.csv")
    m = mean(:api00, rkjk)
    t = total(:api00, rkjk)
    @test m.mean[1] ≈ ref.mean_est[1] rtol = RTOL atol = ATOL
    @test m.SE[1] ≈ ref.mean_se[1] rtol = RTOL atol = ATOL
    @test t.total[1] ≈ ref.total_est[1] rtol = RTOL atol = ATOL
    @test t.SE[1] ≈ ref.total_se[1] rtol = RTOL atol = ATOL
end

@testset "R svychisq (Rao-Scott)" begin
    designs = r_designs()
    for r in eachrow(r_fixture("chisq.csv"))
        d = designs[r.design]
        chF = svychisq(d, :stype, :awards)
        chC = svychisq(d, :stype, :awards; statistic = :Chisq)
        @test chF.statistic[1] ≈ r.F_stat rtol = RTOL atol = ATOL
        @test chF.ndf[1] ≈ r.F_ndf rtol = RTOL atol = ATOL
        @test chF.ddf[1] ≈ r.F_ddf rtol = RTOL atol = ATOL
        @test chF.p_value[1] ≈ r.F_p rtol = RTOL atol = ATOL
        @test chC.statistic[1] ≈ r.Chisq_stat rtol = RTOL atol = ATOL
        @test chC.p_value[1] ≈ r.Chisq_p rtol = RTOL atol = ATOL
    end
end

@testset "R oldsvyquantile (Woodruff CIs)" begin
    designs = r_designs()
    for r in eachrow(r_fixture("quantile.csv"))
        d = designs[r.design]
        q = quantile(:api00, d, r.p; ci = true)
        @test q[1, 1] ≈ r.q rtol = RTOL atol = ATOL
        @test q.SE[1] ≈ r.se rtol = RTOL atol = ATOL
        @test q.ci_lower[1] ≈ r.ci_lower rtol = RTOL atol = ATOL
        @test q.ci_upper[1] ≈ r.ci_upper rtol = RTOL atol = ATOL
    end
end

@testset "R jackknife parity (mean/total SEs)" begin
    designs = r_designs()
    ref = r_fixture("jackknife_parity.csv")
    jk1 = jackknifeweights(designs["clus1_w"])
    jkn = jackknifeweights(designs["strat_w"])
    for (design, name) in [(jk1, "clus1_w_jk1"), (jkn, "strat_w_jkn")]
        r = ref[ref.design.==name, :]
        m = mean(:api00, design)
        t = total(:api00, design)
        @test m.mean[1] ≈ r.mean_est[1] rtol = RTOL atol = ATOL
        @test m.SE[1] ≈ r.mean_se[1] rtol = RTOL atol = ATOL
        @test t.total[1] ≈ r.total_est[1] rtol = RTOL atol = ATOL
        @test t.SE[1] ≈ r.total_se[1] rtol = RTOL atol = ATOL
    end
end
