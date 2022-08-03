# Performance

## Grouping by a single column
**R**

```R
> library(survey)
> library(microbenchmark)
> data(api)
> dclus1 <- svydesign(id = ~dnum, weights = ~pw, data = apiclus1, fpc = ~fpc)
> microbenchmark(svyby(~api00, by = ~cname, design = dclus1, svymean, keep.var = FALSE), units = "us")
```

```R
Unit: microseconds
                                                                   expr
 svyby(~api00, by = ~cname, design = dclus1, svymean, keep.var = FALSE)
      min       lq     mean   median       uq      max neval
 9427.043 10587.81 11269.22 10938.55 11219.24 17620.25   100
```

**Julia**
```julia
using Survey, BenchmarkTools
apiclus1 = load_data("apiclus1")
dclus1 = svydesign(id=:dnum, weights=:pw, data = apiclus1, fpc=:fpc)
@benchmark svyby(:api00, :cname, dclus1, svymean)
```

```julia
BenchmarkTools.Trial: 10000 samples with 1 evaluation.
 Range (min … max):  43.567 μs …   5.905 ms  ┊ GC (min … max): 0.00% … 90.27%
 Time  (median):     53.680 μs               ┊ GC (median):    0.00%
 Time  (mean ± σ):   58.090 μs ± 125.671 μs  ┊ GC (mean ± σ):  4.36% ±  2.00%
```

**The median time is about 198 times lower in Julia as compared to R.**

## Grouping by two columns.

**R**

```R
> library(survey)
> library(microbenchmark)
> data(api)
> dclus1 <- svydesign(id = ~dnum, weights = ~pw, data = apiclus1, fpc = ~fpc)
> microbenchmark(svyby(~api00, by = ~cname+meals, design = dclus1, svymean, keep.var = FALSE), units = "us")
```

```R
Unit: microseconds
                                                                                expr
 svyby(~api00, by = ~cname + meals, design = dclus1, svymean,      keep.var = FALSE)
      min       lq     mean   median       uq      max neval
 120823.6 131472.8 141797.3 134375.8 140818.3 263964.3   100
```

**Julia**
```julia
using Survey, BenchmarkTools
apiclus1 = load_data("apiclus1")
dclus1 = svydesign(id=:dnum, weights=:pw, data = apiclus1, fpc=:fpc)
@benchmark svyby(:api00, [:cname, :meals], dclus1, svymean)
```

```julia
BenchmarkTools.Trial: 10000 samples with 1 evaluation.
 Range (min … max):  64.591 μs …   6.559 ms  ┊ GC (min … max): 0.00% … 77.46%
 Time  (median):     78.204 μs               ┊ GC (median):    0.00%
 Time  (mean ± σ):   89.447 μs ± 235.344 μs  ┊ GC (mean ± σ):  8.48% ±  3.19%
```

 **The median time is about 1718 times lower in Julia as compared to R.**
