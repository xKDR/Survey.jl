@testset "jackknife" begin
    # Create Jackknife replicate designs
    bsrs_jk = srs |> jackknifeweights # SRS
    dstrat_jk = dstrat |> jackknifeweights # Stratified
    dclus2_jk = dclus2 |> jackknifeweights # Two stage cluster
    dnhanes_jk = dnhanes |> jackknifeweights # multistage stratified
    
    mean_srs_jk = mean([:api00,:api99], bsrs_jk)
    @test mean_srs_jk.SE[1] ≈ 9.4028 atol = 1e-3
    @test mean_srs_jk.SE[2] ≈ 9.6575 atol = 1e-3
    
    mean_strat_jk = mean([:api00,:api99],dstrat_jk)
    @test mean_strat_jk.SE[1] ≈ 9.5361 atol = 1e-3
    @test mean_strat_jk.SE[2] ≈ 10.097 atol = 1e-3
    
    mean_clus2_jk = mean([:api00,:api99],dclus2_jk)
    @test mean_clus2_jk.SE[1] ≈ 34.9388 atol = 1e-3 # R gives 34.928
    @test mean_clus2_jk.SE[2] ≈ 34.6565 atol = 1e-3 # R gives 34.645
    
    # Tests using for NHANES
    mean_nhanes_jk = mean([:seq1, :seq2],dnhanes_jk)
    @test mean_nhanes_jk.mean[1] ≈ 21393.96 atol = 1e-3
    @test mean_nhanes_jk.SE[1] ≈ 143.371 atol = 1e-3 # R is slightly diff in 2nd decimal place
    @test mean_nhanes_jk.mean[2] ≈ 38508.328 atol = 1e-3
    @test mean_nhanes_jk.SE[2] ≈ 258.068 atol = 1e-3 # R is slightly diff in 2nd decimal place
end

# # R code for correctness above
# library(survey) 
# data(api)
# apiclus1$pw = rep(757/15,nrow(apiclus1))
# No corrections needed for apiclus2, it has correct weights by default

# #############
# ###### 23.03.22 PR#260

# ## srs with fpc (doesnt match Julia)
# srs <- svydesign(id=~1,data=apisrs, weights=~pw, fpc=~fpc)
# bsrs_jk <- as.svrepdesign(srs, type="JK1", compress=FALSE)
# svymean(~api00,bsrs_jk)
# #         mean     SE
# # api00 656.58 9.2497

# ## srs without fpc (matches Julia)
# srs <- svydesign(id=~1,data=apisrs, weights=~pw)#, fpc=~fpc)
# bsrs_jk <- as.svrepdesign(srs, type="JK1", compress=FALSE)
# svymean(~api00+api99,bsrs_jk)
# #         mean     SE
# # api00 656.58 9.4028
# # api99 624.68 9.6575

# # strat with fpc (doesnt match Julia)
# dstrat <- svydesign(data=apistrat, id=~1, weights=~pw, strata=~stype,fpc=~fpc)
# dstrat_jk <- as.svrepdesign(dstrat, type="JKn", compress=FALSE)
# svymean(~api99,dstrat_jk)
# #         mean     SE
# # api99 629.39 9.9639

# # strat without fpc (matches Julia)
# dstrat <- svydesign(data=apistrat, id=~1, weights=~pw, strata=~stype)#,fpc=~fpc)
# dstrat_jk <- as.svrepdesign(dstrat, type="JKn", compress=FALSE)
# svymean(~api00+api99,dstrat_jk)
# #         mean     SE
# # api00 662.29  9.5361
# # api99 629.39 10.0970

#### apiclus2
# > # clus2 without fpc (doesnt match Julia)
# > dclus2 <- svydesign(id=~dnum+snum, weights=~pw, data=apiclus2)
# > dclus2_jk <- as.svrepdesign(dclus2, type="JK1", compress=FALSE)
# > svymean(~api00+api99,dclus2)
#         mean     SE
# api00 670.81 30.712
# api99 645.03 30.308
# > svymean(~api00+api99,dclus2_jk)
#         mean     SE
# api00 670.81 34.928
# api99 645.03 34.645

# NHANES test
# > data("nhanes")
# > nhanes$seq1 = seq(1.0, 5*8591.0, by = 5)
# > nhanes$seq2 = seq(1.0, 9*8591.0, by = 9)#,  length.out=8591)
# > dnhanes <- svydesign(id=~SDMVPSU, strata=~SDMVSTRA, weights=~WTMEC2YR, nest=TRUE, data=nhanes)
# > svymean(~seq1+seq2,dnhanes)
#       mean     SE
# seq1 21394 143.34
# seq2 38508 258.01
