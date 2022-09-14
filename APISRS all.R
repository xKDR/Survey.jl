library(survey)
data(api)
srs_design <- svydesign(id=~1, fpc=~fpc, data=apisrs) 
srs_design
svytotal(~enroll, srs_design) 
svymean(~enroll, srs_design) 
svyby(~api00, by = ~cname, design = srs, svymean)
nofpc <- svydesign(id=~1, weights=~pw, data=apisrs) 
nofpc 
svytotal(~enroll, nofpc) 
svymean(~enroll, nofpc) 
means <- svymean(~api00+api99, srs_design) 
#grouping by more than one variable
means
svycontrast(means, c(api00=1, api99=-1)) 
srs_design <- update(srs_design, apidiff=api00-api99) 
srs_design <- update(srs_design, apipct = apidiff/api99) 
svymean(~apidiff+apipct, srs_design)
svytotal(~stype, srs_design) #estimates the total number of elementary 
#schools, middle schools, and high schools in California. 
svycontrast(means, quote(api00-api99))#difference between the 1999 and 2000 means



