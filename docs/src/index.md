```@meta
CurrentModule = Survey
```

# Survey

This package is used to study complex survey data. It aims to provide an efficient computing framework for survey analysis.

Surveys are a standard tool for empirical research in social and behavioral sciences, and also widely used by governments and businesses. 
To obtain a better representation of a population and more precise estimates, complex surveys use sampling techniques like clustering, stratification, unequal probability selection or a combination of these. 
Computing population estimates from a survey with corresponding standard errors requires several corrections, weights calibrations and adjustments. A "survey" package automatically applies several of these mathematical techniques and exposes an intuitive API to the user.

Sizes of survey datasets have also been growing with advances in computing power and storage, as well as ease of administering surveys online and over wider geographic areas. This Julia package aims to provide an efficient framework for rapidly growing sizes of survey datasets.

Several software tools are available to study complex surveys[^1]. The [survey package in R](https://cran.r-project.org/web/packages/survey/index.html) is a widely used open-source package.

Discourse [post](https://discourse.julialang.org/t/ann-announcing-survey-jl-for-analysis-of-complex-surveys/94667) announcing the package.

## Current features
Presently, summary statistics such as `mean`, `total`, `ratio`, and `quantile` can be estimated for whole of sample as well as subpopulations/domains using this package. Variance estimation for these estimators are performed using Rao-Wu bootstrap[^2]. Basic visualisations such a scatter plot, histogram and box plot can also be generated. 

The package is built on top of [DataFrames.jl](https://dataframes.juliadata.org/stable/) and supports a variety of features for data manipulation. Plots are generated using [AlgebraOfGraphics](https://github.com/MakieOrg/AlgebraOfGraphics.jl).

Discourse [post](https://discourse.julialang.org/t/ann-announcing-survey-jl-for-analysis-of-complex-surveys/94667) announcing the package.

## Plans
We plan for efficient implementations of all the methods in R `survey`. Features for future releases will include:

- Proportion and count estimation
- Variance by Taylor linearization for `SurveyDesign`
- Support additional replicate weighting algorithms (BRR, Jackknife, other bootstrap flavors) for `ReplicateDesign`
- Better support for more complex survey designs, including more precise estimators for specific designs
- Post-stratification, raking or calibration, GREG estimation and related methods.
- Frequency/contingency table analysis, association tests
- Survival curves and analysis tools
- Integration with [GLM.jl](https://github.com/JuliaStats/GLM.jl)
- Support for [CategoricalsArrays](https://github.com/JuliaData/CategoricalArrays.jl)
- Multivariate analysis, principal components  
- Support for [imputing missing data](https://stat.ethz.ch/CRAN/web/packages/mitools/index.html)
- Integration with [CRRao.jl](https://github.com/xKDR/CRRao.jl) 

## References

[^1]: Comprehensive [list](https://www.hcp.med.harvard.edu/statistics/survey-soft/) of survey analysis software.
[^2]: Rust, Keith F., and J. N. K. Rao. ["Variance estimation for complex surveys using replication techniques."](https://journals.sagepub.com/doi/abs/10.1177/096228029600500305?journalCode=smma), Statistical methods in medical research 5.3 (1996): 283-310.