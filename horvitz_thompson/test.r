library(survey)

data(api)
dclus1 <- svydesign(id = ~dnum, weights = ~pw, data = apiclus1, fpc = ~fpc)
svyby(~api00, by = ~cname, design = dclus1, svymean, keep.var = FALSE)
svyby(~api00, by = ~cname, design = dclus1, svymean)
