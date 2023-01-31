```@meta
CurrentModule = Survey
```

# Survey

This package is used to study complex survey data. It aims to provide a very efficient computing framework for survey analysis, and be a faster alternative to the `survey` package ecosystem in R developed by Prof Thomas Lumley[^lumley].

Surveys are a standard tool for empirical research in social and behavioural sciences, and also widely used by governments and businesses alike. The rapidly growing sizes of survey datasets requires a 

# Why a package for survey analysis in Julia?

Several software tools are available to analyse complex surveys[^list_packages]. The R [survey](https://r-survey.r-forge.r-project.org/survey/) package is a widely used open-source option, but while it excels in expressivity, it's not very performant as it's completely written in R. Generating summary statistics on really large surveys sometimes takes hours. Analytical taylor-series based methods are 

1. There has been interest in a package for survey analysis in the Julia community for quite some time[^2], and some attempts to create a package, which never materialised[^3]. 
2. Julia is able to combine the **expressivity** of R/Python with the **speed** of a systems programming language, so it is ideally placed to be the foundation for a survey analysis framework. 
3. Avoids two-language problem. Fast data frameworks in R or Python usually rely on behind the scenes calls to C, C++, Fortran for speedups, as native interpreted code is usually slow. R `survey` is written in pure R and ease of use, not efficiency, was the main development goal. While there are addons and extensions, a completely Julia-native survey analysis package is great for users as well as long term development and maintenance.
4. The statistical and data ecosytem of Julia has also matured to have substantial statistical computing abilities. `DataFrames.jl` provides the excellent data wrangling and "split-apply-combine" style analytics widely used survey analysis workflows[^dataframes.jl]. `Makie` provides a tightly integrated visualisation backend for graphical analysis of surveys[^makie].

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

Complex surveys involve clustering, stratification, unequal probability sampling or a combination of these.

and Julia language is able to provide a high-level interface while  desired 

Surveys are getting larger and more complex in their design. Packages designed for their analysis have not been able to keep with the increasing complexities. For instance, several survey analysis routines used in our organisation (based on R `survey`) take hours to compute


