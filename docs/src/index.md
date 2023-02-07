```@meta
CurrentModule = Survey
```

# Survey

This package is used to study complex survey data. It aims to provide an efficient computing framework for survey analysis.

Surveys are a standard tool for empirical research in social and behavioral sciences, and also widely used by governments and businesses alike. In order to get a better representation or more precise estimates, complex surveys use sophisticated sampling techniques like clustering, stratification, unequal probability selection or a combination of these. Computing population estimates from a survey with corresponding standard errors requires several corrections, weights calibrations and adjustments, wherein stems the need for a "survey" package which automatically applies these mathematical techniques.

Several software tools are available to study complex surveys[^1]. The [survey package in R](https://cran.r-project.org/web/packages/survey/index.html) is a widely used open-source package. 

Sizes of survey datasets has been growing with advances in computing power and storage, as well as ease of administering surveys online over longer distances and wider geographic areas. The rapidly growing sizes of survey datasets requires an efficient computing framework. This Julia package aims to provide such a framework. 

Presently, summary statistics such as `mean`, `total`, `ratio`, and `quantile` can be estimated for whole of sample as well as subpopulations/domains using this package. Variance estimation for these estimators are performed using Rao-Wu bootstrap[^2]. Visualisations such a scatter plot, histogram and box plot can also be generated. 

The package is built on top of [DataFrames.jl](https://dataframes.juliadata.org/stable/) and all its rich set of features are available for data manipulation. Plots are generated using [AlgebraOfGraphics](https://github.com/MakieOrg/AlgebraOfGraphics.jl). Its features can be accessed via keyword arguments.  

## Plans
We plan for efficient implementations of all the methods in R `survey`. Features for future releases will include:

- Variance by Taylor linearization for `SurveyDesign`
- Support additional replicate weighting algorithms (BRR, Jackknife, other bootstrap flavors) for `ReplicateDesign`
- Support for more complex survey designs
- Post-stratification, raking or calibration, GREG estimation and related methods.
- Contingency table analysis, support for [CategoricalArrays](https://github.com/JuliaData/CategoricalArrays.jl)
- Integration with [CRRao.jl](https://github.com/xKDR/CRRao.jl) for regressions, with design based standard errors. 
- Integration with [GLM.jl](https://github.com/JuliaStats/GLM.jl)
- Support for [CategoricalsArrays](https://github.com/JuliaData/CategoricalArrays.jl)
- Association and likelihood ratio tests
- Support for [imputing missing data](https://stat.ethz.ch/CRAN/web/packages/mitools/index.html)

## References

[^1]: Alan Zaslavsky keeps a comprehensive [list](https://www.hcp.med.harvard.edu/statistics/survey-soft/) of survey analysis software for the ASA Section on Survey Research Methods.
[^2]: [Rust, Keith F., and J. N. K. Rao. "Variance estimation for complex surveys using replication techniques." Statistical methods in medical research 5.3 (1996): 283-310.](https://journals.sagepub.com/doi/abs/10.1177/096228029600500305?journalCode=smma)