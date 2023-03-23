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
    
    # mean(:api00,dclus2_jk)
    # mean(,dnhanes_jk)
end

# # R code for correctness above
# library(survey) 
# data(api)
# apiclus1$pw = rep(757/15,nrow(apiclus1))

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