# Moving from R to Julia
This section presents examples to help move from R to Julia. Examples show R and Julia code for common operations in survey analysis. <br>
For the same operation, first the R and then the Julia code is presented. 

## Simple random sample

The `apisrs` data, which is provided in both `survey` and `Survey.jl`, is used as an example. It's a simple random sample of the Academic Performance Index of Californian schools.

### 1. Creating a design object
Instantiating a simple random sample survey design.

```R
library(survey)
data(api)
dsrs = svydesign(id = ~1, data = apisrs, weights = ~pw, fpc = ~fpc)
```

```julia
using Survey
srs = load_data("apisrs")
dsrs = SimpleRandomSample(srs; popsize = :fpc)
```

### 2. Mean
In the following example the mean of the variable `api00` is calculated. 

```R
svymean(~api00, dsrs)
```
```julia
mean(:api00, dsrs)
```

### 3. Total
In the following example the sum of the variable `api00` is calculated. 

```R
svytotal(~api00, dsrs)
```
```julia
total(:api00, dsrs)
```

### 4. Quantile
In the following example the median of the variable `api00` is calculated.
```R
svyquantile(~api00, dsrs, 0.5)
```
```julia
quantile(:api00, dsrs, 0.5)
```

### 5. Domain estimation
In the following example the mean of the variable `api00` is calculated grouped by the variable `cname`. 

```R
svyby(~api00, ~cname, dsrs, svymean)
```

```julia
by(:api00, :cname, dsrs, mean)
```

## Stratified sample

The `apistrat` data, which is provided in both `survey` and `Survey`, is used as an example. It's a stratified sample of the Academic Performance Index of Californian schools.

### 1. Creating a design object
The following example shows how to construct a design object for a stratified sample. 

```R
library(survey)
data(api)
dstrat = svydesign(id = ~1, data = apistrat, strata = ~stype, weights = ~pw, fpc = ~fpc)
```

```julia
using Survey
strat = load_data("apistrat")
dstrat = StratifiedSample(strat, :stype; popsize  = :fpc)
```

### 2. Mean
In the following example the mean of the variable `api00` is calculated. 

```R
svymean(~api00, dstrat)
```
```julia
mean(:api00, dstrat)
```

### 3. Total
In the following example the sum of the variable `api00` is calculated. 

```R
svytotal(~api00, dstrat)
```
```julia
total(:api00, dstrat)
```

### 4. Quantile
In the following example the median of the variable `api00` is calculated.
```R
svyquantile(~api00, dstrat, 0.5)
```
```julia
quantile(:api00, dstrat, 0.5)
```

### 5. Domain estimation
In the following example the mean of the variable `api00` is calculated grouped by the variable `cname`. 

```R
svyby(~api00, ~cname, dstrat, svymean)
```

```julia
by(:api00, :cname, dstrat, mean)
```