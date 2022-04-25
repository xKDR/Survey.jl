In the following examples, we'll compare R and Julia for performing the same set of operations. 

# Installing and loading the package 

```r
install.package("survey")
library(survey)
```

```julia
using Pkg
Pkg.add(url = "https://github.com/xKDR/Survey.jl.git")
```

# Data

The input data for the Survey package should be a DataFrame object. In this example, we'll use the apiclus1 data from the api dataset. 
```r
data(api) 
```

This loads the apiclus1 data as apiclus1 variable.  

```julia
data(api)
```

This also loads the apiclus1 data as apiclus1 variable.  

# svydesign
```r
dclus1<-svydesign(id=~dnum, weights=~pw, data=apiclus1, fpc=~fpc)
```

```julia
dclus1 = svydesign(id= :dnum, weights= :pw, data = apiclus1, fpc= :fpc
```

# svyby

## Mean

```r
svyby(~api00, design = dclus1, svymean)
svyby(~api00, by =~cname, design = dclus1, svymean)
```

```julia
svyby(:api00, dclus1, svymean)
svyby(:api00, :cname, dclus1, svymean)
```

## Sum

```r
svyby(~api00, by =~cname, design = dclus1, svytotal)
```

```julia
svyby(:api00, dclus1, svytotal)
```

## Quantile

```r
svyby(~api00, by =~cname, design = dclus1, svyquantile, quantile = 0.63)

```

```julia
svyby(:api00, :cname, dclus1, svyquantile, 0.63)
```