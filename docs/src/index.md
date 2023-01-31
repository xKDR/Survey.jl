```@meta
CurrentModule = Survey
```

# Survey

This package is used to study complex survey data. It aims to provide a very efficient computing framework for survey analysis, and be a faster alternative to the `survey` package ecosystem in R developed by Prof Thomas Lumley[^lumley].

Surveys are a standard tool for empirical research in social and behavioural sciences, and also widely used by governments and businesses alike. In order to get a better representation or more precise estimates, complex surveys use sophisticated sampling techniques like clustering, stratification, unequal probability selection or a combination of these. Computing population estimates from a survey is not as simple as `mean(x)`, and requires several corrections, weights calibrations and adjustments, wherein stems the need for a "survey" package which automatically applies these mathematical techniques. Size of survey datasets has been slowly increasing over the past few decades with advances in computing power and storage, as well as ease of administering surveys online over longer distances and wider geographic areas. The rapidly growing sizes of survey datasets requires an efficient computing system. 

# Why a package for survey analysis in Julia?

## Julia is better in many classes of problems
Several software tools are available to analyse complex surveys[^list_packages]. The R [survey](https://r-survey.r-forge.r-project.org/survey/) package is a widely used open-source option, but while it excels in expressivity, it's not very performant as it's completely written in R. Generating summary statistics on really large surveys sometimes takes hours. Analytical taylor-series based methods for variances are reasonably fast, but replicate weights based methods are painfully slow. A great number of surveys these days provide replicate weights instead of probability weights for statistical disclosure control purposes. In this class of simulation problems, Julia has a substantial edge over R.
## Advantages of Julia `Survey.jl`
1. There has been interest in a package for survey analysis in the Julia community for quite some time[^2], and some attempts to create a package, which never materialised[^3]. 
2. Julia is able to combine the **expressivity** of R/Python with the **speed** of a systems programming language, so it is ideally placed to be the foundation for a survey analysis framework. 
3. Avoids two-language problem. Fast data frameworks in R or Python usually rely on behind the scenes calls to C, C++, Fortran for speedups, as native interpreted code is usually slow. R `survey` is written in pure R and ease of use, not efficiency, was the main development goal. While there are addons and extensions, a completely Julia-native survey analysis package is great for users as well as long term development and maintenance.
4. The statistical and data ecosytem of Julia has also matured to have substantial statistical computing abilities. `DataFrames.jl` provides the excellent data wrangling and "split-apply-combine" style analytics widely used survey analysis workflows[^dataframes.jl]. `Makie` provides a tightly integrated visualisation backend for graphical analysis of surveys[^makie]. `LinearAlgebra` and `Optim` as well as auto-differentiation libraries provide cutting edge foundations for further statistical modelling and analysis.

# Future plans
We plan for efficient implementations of all the methods in R `survey`. Features for future releases will include:

- Variance by Taylor linearization for `SurveyDesign`
- Support additional replicate weighting algorithms (BRR, Jackknife, other bootstrap flavours) for `ReplicateDesign`
- Support for more complex survey designs
- Post-stratification, raking or calibration, GREG estimation and related methods.
- Code analysis and optimisation
- Contingency table analysis, support for [CategoricalArrays](https://github.com/JuliaData/CategoricalArrays.jl)
- Wrappers and connection with [GLM.jl](https://github.com/JuliaStats/GLM.jl)
- Support and speedups with [CategoricalsArrays](https://github.com/JuliaData/CategoricalArrays.jl)
- Association and likelihood ratio tests
- Support for [imputing missing data](https://stat.ethz.ch/CRAN/web/packages/mitools/index.html)
- Bayesian surveys

[^makie]: See [Makie project](https://docs.makie.org/stable/)
[^dataframes.jl]: See [DataFrames.jl](https://dataframes.juliadata.org/stable/) documentation
[^R_survey]: [R survey package](https://cran.r-project.org/web/packages/survey/index.html)
[^lumley]: [Thomas Lumley Homepage](https://www.stat.auckland.ac.nz/people/tlum005)
[^list_packages]: Alan Zaslavsky keeps a comprehensive [list](https://www.hcp.med.harvard.edu/statistics/survey-soft/) of survey analysis software for the ASA Section on Survey Research Methods.
[^2]: see Julia Discourse posts [here](https://discourse.julialang.org/t/any-package-for-survey-data-analysis/67317) and [here](https://discourse.julialang.org/t/analysis-of-complex-surveys-in-julia/44011) 
[^3]: see [samplics](https://github.com/samplics-org/survey.jl) and [jamanrique](https://github.com/jamanrique/SurveyAnalysis.jl).