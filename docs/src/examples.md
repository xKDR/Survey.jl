In the following examples, we'll compare R and Julia for performing the same set of operations. 

# Installing and loading the package 
### R code

```r
install.package("survey")
library(survey)
```

### Julia code
```julia
using Pkg
Pkg.add(url = "https://github.com/xKDR/Survey.jl.git")
using Survey
```

The following command in the Pkg REPL may also be used to install the package. 
```
add "https://github.com/xKDR/Survey.jl.git"
```

# API data

[The Academic Performance Index is computed for all California schools based on standardised
testing of students. The data sets contain information for all schools with at least 100 students and
for various probability samples of the data. apiclus1 is a cluster sample of school districts, apistrat is a sample stratified by stype.](https://cran.r-project.org/web/packages/survey/survey.pdf)

In the following examples, we'll use the apiclus1 data from the api dataset. 

The api dataset can be loaded using the following command:

### R
```r
data(api) 
```

### Julia
```julia
data(api)
```

# svydesign
[The ```svydesign``` object combines a data frame and all the survey design information needed to analyse it.](https://www.rdocumentation.org/packages/survey/versions/4.1-1/topics/svydesign)

A ```svydesign``` object can be constructed with the following command:

### R
```r
dclus1 <-svydesign(id = ~dnum, weights = ~pw, data = apiclus1, fpc = ~fpc)
```

### Julia
```julia
dclus1 = svydesign(id = :dnum, weights = :pw, data = apiclus1, fpc = :fpc)
```

# svyby
The svyby function can be used to generate stratified estimates.

## Mean
Weighted mean of a variable by strata can be computed using the following command: 

### R
```r
svyby(~api00, by = ~cname, design = dclus1, svymean)
```

### Julia
```julia
svyby(:api00, :cname, dclus1, svymean)
```

## Sum
Weighted sum of a variable by strata can be computed using the following command: 

### R
```r
svyby(~api00, by = ~cname, design = dclus1, svytotal)
```

### Julia
```julia
svyby(:api00, :cname, dclus1, svytotal)
```

## Quantile
Weighted quantile of a variable by strata can be computed using the following command: 

### R
```r
svyby(~api00, by = ~cname, design = dclus1, svyquantile, quantile = 0.63)
```
### Julia
```julia
svyby(:api00, :cname, dclus1, svyquantile, 0.63)
```