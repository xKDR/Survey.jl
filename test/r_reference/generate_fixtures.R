# Generate reference values from the R `survey` package for Survey.jl tests.
#
# Run from this directory:
#   Rscript generate_fixtures.R
#
# Requires: install.packages("survey")
# Generated with survey 4.5 on R 4.6.1. The api, scd and nhanes datasets shipped
# with Survey.jl are identical to the ones in the R survey package, so estimates
# are comparable to machine precision.

library(survey)
data(api)
data(scd)
data(nhanes)

options(digits = 15)
fmt <- function(x) as.numeric(x)

## ---------------------------------------------------------------- designs
d_srs_w      <- svydesign(id = ~1, weights = ~pw, data = apisrs)
d_srs_fpc    <- svydesign(id = ~1, fpc = ~fpc, data = apisrs)
d_strat_w    <- svydesign(id = ~1, strata = ~stype, weights = ~pw, data = apistrat)
d_strat_fpc  <- svydesign(id = ~1, strata = ~stype, fpc = ~fpc, data = apistrat)
d_clus1_w    <- svydesign(id = ~dnum, weights = ~pw, data = apiclus1)
d_clus1_fpc  <- svydesign(id = ~dnum, fpc = ~fpc, data = apiclus1)
d_nhanes     <- svydesign(id = ~SDMVPSU, strata = ~SDMVSTRA, weights = ~WTMEC2YR,
                          nest = TRUE, data = nhanes)

designs <- list(srs_w = d_srs_w, srs_fpc = d_srs_fpc,
                strat_w = d_strat_w, strat_fpc = d_strat_fpc,
                clus1_w = d_clus1_w, clus1_fpc = d_clus1_fpc)

## -------------------------------------------------- mean/total/ratio + degf
rows <- list()
for (nm in names(designs)) {
  d <- designs[[nm]]
  for (v in c("api00", "enroll")) {
    f <- as.formula(paste0("~", v))
    m <- svymean(f, d); t <- svytotal(f, d)
    rows[[length(rows)+1]] <- data.frame(design = nm, variable = v, stat = "mean",
                                         est = fmt(coef(m)), se = fmt(SE(m)))
    rows[[length(rows)+1]] <- data.frame(design = nm, variable = v, stat = "total",
                                         est = fmt(coef(t)), se = fmt(SE(t)))
  }
  r <- svyratio(~api00, ~enroll, d)
  rows[[length(rows)+1]] <- data.frame(design = nm, variable = "api00/enroll",
                                       stat = "ratio", est = fmt(coef(r)),
                                       se = fmt(SE(r)))
}
# nhanes: stratified cluster design (nested PSU ids)
m <- svymean(~race, d_nhanes); t <- svytotal(~race, d_nhanes)
rows[[length(rows)+1]] <- data.frame(design = "nhanes", variable = "race",
                                     stat = "mean", est = fmt(coef(m)), se = fmt(SE(m)))
rows[[length(rows)+1]] <- data.frame(design = "nhanes", variable = "race",
                                     stat = "total", est = fmt(coef(t)), se = fmt(SE(t)))
write.csv(do.call(rbind, rows), "est_basic.csv", row.names = FALSE)

degf_rows <- data.frame(design = c(names(designs), "nhanes"),
                        degf = sapply(c(designs, list(nhanes = d_nhanes)), degf))
write.csv(degf_rows, "degf.csv", row.names = FALSE)

## ------------------------------------------------------------- proportions
rows <- list()
for (nm in names(designs)) {
  d <- designs[[nm]]
  for (v in c("stype", "awards")) {
    f <- as.formula(paste0("~", v))
    m <- svymean(f, d); t <- svytotal(f, d)
    lv <- levels(factor(d$variables[[v]]))
    rows[[length(rows)+1]] <- data.frame(design = nm, variable = v, level = lv,
                                         mean_est = fmt(coef(m)), mean_se = fmt(SE(m)),
                                         total_est = fmt(coef(t)), total_se = fmt(SE(t)))
  }
}
write.csv(do.call(rbind, rows), "proportions.csv", row.names = FALSE)

## ----------------------------------------------------------------- domains
dom <- function(d, y, by) {
  b1 <- svyby(as.formula(paste0("~", y)), as.formula(paste0("~", by)), d, svymean)
  b2 <- svyby(as.formula(paste0("~", y)), as.formula(paste0("~", by)), d, svytotal)
  data.frame(domain = as.character(b1[[by]]),
             mean_est = fmt(b1[[y]]), mean_se = fmt(b1$se),
             total_est = fmt(b2[[y]]), total_se = fmt(b2$se))
}
r1 <- cbind(design = "clus1_w",   by = "cname",  dom(d_clus1_w, "api00", "cname"))
r2 <- cbind(design = "clus1_fpc", by = "cname",  dom(d_clus1_fpc, "api00", "cname"))
r3 <- cbind(design = "strat_fpc", by = "awards", dom(d_strat_fpc, "api00", "awards"))
write.csv(rbind(r1, r2, r3), "domain.csv", row.names = FALSE)

## ---------------------------------------------------------------- variance
rows <- list()
for (nm in names(designs)) {
  v <- svyvar(~api00, designs[[nm]])
  rows[[length(rows)+1]] <- data.frame(design = nm, est = fmt(coef(v)), se = fmt(SE(v)))
}
# replicate (jackknife) version
jk_strat <- as.svrepdesign(d_strat_w, type = "JKn", mse = TRUE)
v <- svyvar(~api00, jk_strat)
rows[[length(rows)+1]] <- data.frame(design = "strat_w_jkn", est = fmt(coef(v)), se = fmt(SE(v)))
write.csv(do.call(rbind, rows), "variance.csv", row.names = FALSE)

## ----------------------------------------------------------------- confint
rows <- list()
for (nm in names(designs)) {
  d <- designs[[nm]]
  m <- svymean(~api00, d)
  ci_n <- confint(m, level = 0.95)                 # normal quantiles
  ci_t <- confint(m, level = 0.95, df = degf(d))   # t quantiles
  rows[[length(rows)+1]] <- data.frame(design = nm,
                                       normal_lower = fmt(ci_n[1]), normal_upper = fmt(ci_n[2]),
                                       t_lower = fmt(ci_t[1]), t_upper = fmt(ci_t[2]))
}
write.csv(do.call(rbind, rows), "confint.csv", row.names = FALSE)

## ---------------------------------------------------------------- svytable
tab <- as.data.frame(svytable(~stype + awards, d_strat_w))
write.csv(cbind(design = "strat_w", tab), "svytable_strat.csv", row.names = FALSE)
tab <- as.data.frame(svytable(~stype + awards, d_clus1_w))
write.csv(cbind(design = "clus1_w", tab), "svytable_clus1.csv", row.names = FALSE)
tab1 <- as.data.frame(svytable(~stype, d_strat_w))
write.csv(cbind(design = "strat_w", tab1), "svytable_oneway.csv", row.names = FALSE)

## ------------------------------------------------------------------ ttest
rows <- list()
for (nm in c("srs_w", "strat_fpc", "clus1_w")) {
  tt <- svyttest(api00 ~ comp.imp, designs[[nm]])
  rows[[length(rows)+1]] <- data.frame(design = nm,
                                       est = fmt(tt$estimate), t = fmt(tt$statistic),
                                       df = fmt(tt$parameter), p = fmt(tt$p.value),
                                       ci_lower = fmt(tt$conf.int[1]),
                                       ci_upper = fmt(tt$conf.int[2]))
}
write.csv(do.call(rbind, rows), "ttest.csv", row.names = FALSE)

## ------------------------------------------------------------- trimWeights
dtr <- trimWeights(d_strat_w, upper = 40)
write.csv(data.frame(snum = apistrat$snum, weight = fmt(weights(dtr))),
          "trimweights_weights.csv", row.names = FALSE)
m <- svymean(~api00, dtr)
write.csv(data.frame(est = fmt(coef(m)), se = fmt(SE(m))),
          "trimweights_mean.csv", row.names = FALSE)

## ------------------------------------------------------------ BRR and Fay
# scd: 3 strata (ESA) x 2 PSUs (ambulance, nested) -> hadamard(3) = Sylvester H4
scd$w <- 1
d_scd <- svydesign(data = scd, weights = ~w, id = ~ambulance, strata = ~ESA, nest = TRUE)
brr <- as.svrepdesign(d_scd, type = "BRR", mse = TRUE)
fay <- as.svrepdesign(d_scd, type = "Fay", fay.rho = 0.3, mse = TRUE)
aw_brr <- weights(brr, type = "analysis")
colnames(aw_brr) <- paste0("replicate_", 1:ncol(aw_brr))
write.csv(cbind(scd[c("ESA", "ambulance")], aw_brr), "brr_scd_repweights.csv", row.names = FALSE)
rows <- list()
for (v in c("alive", "arrests")) {
  f <- as.formula(paste0("~", v))
  mb <- svymean(f, brr); tb <- svytotal(f, brr)
  mf <- svymean(f, fay); tf <- svytotal(f, fay)
  rows[[length(rows)+1]] <- data.frame(variable = v,
    brr_mean = fmt(coef(mb)), brr_mean_se = fmt(SE(mb)),
    brr_total = fmt(coef(tb)), brr_total_se = fmt(SE(tb)),
    fay_mean = fmt(coef(mf)), fay_mean_se = fmt(SE(mf)),
    fay_total = fmt(coef(tf)), fay_total_se = fmt(SE(tf)))
}
write.csv(do.call(rbind, rows), "brr_scd_results.csv", row.names = FALSE)

# synthetic: 7 strata x 2 PSUs, varying weights -> hadamard(7) = Sylvester H8
set.seed(1)
brrdat <- data.frame(stratum = rep(paste0("S", 1:7), each = 6),
                     psu = rep(1:14, each = 3),
                     y = round(rnorm(42, 50, 10), 6),
                     w = round(runif(42, 5, 15), 6))
write.csv(brrdat, "brr_synth_data.csv", row.names = FALSE)
d_synth <- svydesign(data = brrdat, weights = ~w, id = ~psu, strata = ~stratum)
brr_s <- as.svrepdesign(d_synth, type = "BRR", mse = TRUE)
fay_s <- as.svrepdesign(d_synth, type = "Fay", fay.rho = 0.5, mse = TRUE)
mb <- svymean(~y, brr_s); tb <- svytotal(~y, brr_s)
mf <- svymean(~y, fay_s); tf <- svytotal(~y, fay_s)
write.csv(data.frame(
  brr_mean = fmt(coef(mb)), brr_mean_se = fmt(SE(mb)),
  brr_total = fmt(coef(tb)), brr_total_se = fmt(SE(tb)),
  fay_mean = fmt(coef(mf)), fay_mean_se = fmt(SE(mf)),
  fay_total = fmt(coef(tf)), fay_total_se = fmt(SE(tf))),
  "brr_synth_results.csv", row.names = FALSE)

## ----------------------------------------------- postStratify (JK for SEs)
pop.types <- data.frame(stype = c("E", "H", "M"), Freq = c(4421, 755, 1018))
ps <- postStratify(d_clus1_w, ~stype, pop.types)
write.csv(data.frame(snum = apiclus1$snum, weight = fmt(weights(ps))),
          "poststratify_weights.csv", row.names = FALSE)
jk_clus1 <- as.svrepdesign(d_clus1_w, type = "JK1", mse = TRUE)
psjk <- postStratify(jk_clus1, ~stype, pop.types)
m <- svymean(~api00, psjk); t <- svytotal(~api00, psjk)
mps <- svymean(~api00, ps)
write.csv(data.frame(mean_est = fmt(coef(m)), mean_se = fmt(SE(m)),
                     total_est = fmt(coef(t)), total_se = fmt(SE(t)),
                     lin_mean_est = fmt(coef(mps)), lin_mean_se = fmt(SE(mps))),
          "poststratify_results.csv", row.names = FALSE)

## ------------------------------------------------------- rake (JK for SEs)
pop.schwide <- data.frame(sch.wide = c("No", "Yes"), Freq = c(1072, 5122))
rk <- rake(d_clus1_w, list(~stype, ~sch.wide), list(pop.types, pop.schwide))
write.csv(data.frame(snum = apiclus1$snum, weight = fmt(weights(rk))),
          "rake_weights.csv", row.names = FALSE)
rkjk <- rake(jk_clus1, list(~stype, ~sch.wide), list(pop.types, pop.schwide))
m <- svymean(~api00, rkjk); t <- svytotal(~api00, rkjk)
write.csv(data.frame(mean_est = fmt(coef(m)), mean_se = fmt(SE(m)),
                     total_est = fmt(coef(t)), total_se = fmt(SE(t))),
          "rake_results.csv", row.names = FALSE)

## ----------------------------------------------------------------- chisq
rows <- list()
for (nm in c("srs_w", "strat_fpc", "clus1_w")) {
  d <- designs[[nm]]
  chF <- svychisq(~stype + awards, d, statistic = "F")
  chC <- svychisq(~stype + awards, d, statistic = "Chisq")
  rows[[length(rows)+1]] <- data.frame(design = nm,
    F_stat = fmt(chF$statistic), F_ndf = fmt(chF$parameter[1]),
    F_ddf = fmt(chF$parameter[2]), F_p = fmt(chF$p.value),
    Chisq_stat = fmt(chC$statistic), Chisq_p = fmt(chC$p.value))
}
write.csv(do.call(rbind, rows), "chisq.csv", row.names = FALSE)

## ------------------------------------------- quantiles with Woodruff CIs
rows <- list()
for (nm in names(designs)) {
  d <- designs[[nm]]
  q <- oldsvyquantile(~api00, d, c(0.25, 0.5, 0.75), ci = TRUE,
                      interval.type = "Wald", ties = "discrete")
  for (i in 1:3) {
    rows[[length(rows)+1]] <- data.frame(design = nm, p = c(0.25, 0.5, 0.75)[i],
                                         q = fmt(q$quantiles[i]),
                                         ci_lower = fmt(q$CIs[1, i, 1]),
                                         ci_upper = fmt(q$CIs[2, i, 1]),
                                         se = fmt(attr(q, "SE")[i]))
  }
}
write.csv(do.call(rbind, rows), "quantile.csv", row.names = FALSE)

## ------------------------------------- jackknife parity for mean/total SE
jk1 <- as.svrepdesign(d_clus1_w, type = "JK1", mse = TRUE)
m1 <- svymean(~api00, jk1); t1 <- svytotal(~api00, jk1)
mn <- svymean(~api00, jk_strat); tn <- svytotal(~api00, jk_strat)
write.csv(data.frame(design = c("clus1_w_jk1", "strat_w_jkn"),
                     mean_est = c(fmt(coef(m1)), fmt(coef(mn))),
                     mean_se = c(fmt(SE(m1)), fmt(SE(mn))),
                     total_est = c(fmt(coef(t1)), fmt(coef(tn))),
                     total_se = c(fmt(SE(t1)), fmt(SE(tn)))),
          "jackknife_parity.csv", row.names = FALSE)

cat("All fixtures written.\n")
