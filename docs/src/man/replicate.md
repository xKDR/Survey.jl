# Replicate weights

Replicate weights are a method for estimating the standard errors of survey statistics in complex sample designs.

The basic idea behind replicate weights is to create multiple versions of the original sample weights, each with small, randomly generated perturbations. The multiple versions of the sample weights are then used to calculate the survey statistic of interest, such as the mean or total, on multiple replicate samples. The variance of the survey statistic is then estimated by computing the variance across the replicate samples.

Currently, the package supports two bootstrap methods and the Jackknife method for generating replicate weights:

- **Rao-Wu bootstrap** (`bootweights`): Uses (n-1) sampling with scaling factor n/(n-1)
- **Canty-Davison bootstrap** (`canty_davison_bootstrap`): Uses n sampling without additional scaling
- **Jackknife** (`jackknifeweights`): Delete-1 jackknife resampling

The `bootweights` function generates a `ReplicateDesign` using the Rao-Wu bootstrap method:

```@repl bootstrap
using Survey
apistrat = load_data("apistrat")
dstrat = SurveyDesign(apistrat; strata=:stype, weights=:pw)
bstrat = bootweights(dstrat; replicates = 10)
```

The `canty_davison_bootstrap` function generates a `ReplicateDesign` using the Canty-Davison bootstrap method:

```@repl bootstrap
cd_strat = canty_davison_bootstrap(dstrat; replicates = 10)
```

The `jackknifeweights` function generates a `ReplicateDesign` using the Jackknife method:

```@repl bootstrap
using Survey
apistrat = load_data("apistrat")
dstrat = SurveyDesign(apistrat; strata=:stype, weights=:pw)
rstrat = jackknifeweights(dstrat)
```

For each replicate, the `DataFrame` of `ReplicateDesign` has an additional column. The name of the column is `replicate_` followed by the replicate number.

```@repl bootstrap
names(bstrat.data)
```

`replicate_1`, `replicate_2`, `replicate_3`, `replicate_4`, `replicate_5`, `replicate_6`, `replicate_7`, `replicate_8`, `replicate_9`, `replicate_10`, are the replicate weight columns.

While a `SurveyDesign` can be used to estimate a statistics. For example:

```@repl bootstrap
mean(:api00, dstrat)
```

The `ReplicateDesign` can be used to compute the standard error of the statistic. For example:

```@repl bootstrap
mean(:api00, bstrat)
```

```

For each replicate weight, the statistic is calculated using it instead of the weight. The standard deviation of those statistics is the standard error of the estimate.

## References

[^1]: [Rust, Keith F., and J. N. K. Rao. "Variance estimation for complex surveys using replication techniques." Statistical methods in medical research 5.3 (1996): 283-310.](https://journals.sagepub.com/doi/abs/10.1177/096228029600500305?journalCode=smma)
[^2]: [Miller, Rupert G. "The Jackknife--A Review." Biometrika 61, no. 1 (1974): 1–15. https://doi.org/10.2307/2334280.](https://www.jstor.org/stable/2334280)
[^3]: [Canty, A., & Davison, A. C. (1999). Resampling-based variance estimation for labour force surveys. Journal of the Royal Statistical Society: Series D (The Statistician), 48(3), 379-391.](https://doi.org/10.1111/1467-9884.00187)

## References

[^1]: [Rust, Keith F., and J. N. K. Rao. "Variance estimation for complex surveys using replication techniques." Statistical methods in medical research 5.3 (1996): 283-310.](https://journals.sagepub.com/doi/abs/10.1177/096228029600500305?journalCode=smma)
[^2]: [Miller, Rupert G. "The Jackknife--A Review." Biometrika 61, no. 1 (1974): 1–15. https://doi.org/10.2307/2334280.](https://www.jstor.org/stable/2334280)
[^3]: [Canty, A., & Davison, A. C. (1999). Resampling-based variance estimation for labour force surveys. Journal of the Royal Statistical Society: Series D (The Statistician), 48(3), 379-391.](https://doi.org/10.1111/1467-9884.00187)  

## References

[^1]: [Rust, Keith F., and J. N. K. Rao. "Variance estimation for complex surveys using replication techniques." Statistical methods in medical research 5.3 (1996): 283-310.](https://journals.sagepub.com/doi/abs/10.1177/096228029600500305?journalCode=smma)
[^2]: [Miller, Rupert G. “The Jackknife--A Review.” Biometrika 61, no. 1 (1974): 1–15. https://doi.org/10.2307/2334280.](https://www.jstor.org/stable/2334280)