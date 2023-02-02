```@meta
CurrentModule = Survey
```

# Survey

This package is used to study complex survey data. It aims to provide an efficient computing framework for survey analysis, and be a faster alternative to the `survey` package ecosystem in R developed by Prof Thomas Lumley[^1].

Surveys are a standard tool for empirical research in social and behavioral sciences, and also widely used by governments and businesses alike. In order to get a better representation or more precise estimates, complex surveys use sophisticated sampling techniques like clustering, stratification, unequal probability selection or a combination of these. Computing population estimates from a survey with corresponding standard errors requires several corrections, weights calibrations and adjustments, wherein stems the need for a "survey" package which automatically applies these mathematical techniques.

Several software tools are available to study complex surveys[^10]. The R[^12](https://r-survey.r-forge.r-project.org/survey/) package is a widely used open-source package. 

## Why a package for survey analysis in Julia?

### Performance with expressivity 
Sizes of survey datasets has been growing with advances in computing power and storage, as well as ease of administering surveys online over longer distances and wider geographic areas. The rapidly growing sizes of survey datasets requires an efficient computing framework. 

While the R package excels in *expressivity*, *performance* was not a key development goal[^13]. Users of this package have waited hours/days in R generating summary statistics (with  standard errors) on really large surveys[^11].

Julia is able to combine the **expressivity** of R with the **speed** of a systems programming language. 

### Development and maintenance
1. While the R package's performance can be improved by writing functions in C/C++/FORTRAN [^7], a multilanguage package is harder for the community develop and maintain. Julia avoids the two language problem. Statisticians can contribute to a Julia package without worrying about intricate computer engineering challenges introduced by lower level languages. 
2. Julia packages are built on GitHub. It makes easy for multiple developers to work together on a project. At the same time, it makes it easier for users to file bug reports and issues. Through workflows, GitHub integrates with a variety of tools, making it easier for developers to automate their workflow and manage their projects.  

### Statistical ecosystem

1. The data science ecosystem in Julia excels as it has evolved learning from its competitors in other languages. `DataFrames`[^3] provides an efficient and expressive framework for tabular data manipulation. `Makie` provides a tightly integrated visualisation backend for graphical analysis. 
2. The combination of expressivity and performance has given rise to many cutting edge work such are probabilistic programming in `Turing`[^4] and automatic differentiation in `Optim`[^6].    
For these reasons, a survey package in Julia built on this ecosystem can be *better* than those in other languages and also be a platform to implement cutting edge statistical methods.  

### Community interest

There has been interest in a package for survey analysis in the Julia community[^8], and several attempts to create a package, which never materialised[^9]. In the course of development of the package, we received positive feedback and even contributing PRs on the project[^5].

## Highlights
Current feature highlights include:
- Data manipulation and analysis are implemented using DataFrames.jl.
- Summary statistics such as `mean`, `total`, `ratio`, and `quantile` for whole of sample as well as subpopulations/domains.
- Variance estimation using resampling techniques (current default Rao-Wu bootstrap)
- Single stage approximation of multistage sampling schemes
- Common graphical analysis functions using [AlgebraOfGraphics](https://github.com/MakieOrg/AlgebraOfGraphics.jl) backend
- Inspired by the familiar R [survey](https://r-survey.r-forge.r-project.org/survey/), and related package interface in the R ecosystem.

## Plans
We plan for efficient implementations of all the methods in R `survey`. Features for future releases will include:

- Variance by Taylor linearization for `SurveyDesign`
- Support additional replicate weighting algorithms (BRR, Jackknife, other bootstrap flavours) for `ReplicateDesign`
- Support for more complex survey designs
- Post-stratification, raking or calibration, GREG estimation and related methods.
- Contingency table analysis, support for [CategoricalArrays](https://github.com/JuliaData/CategoricalArrays.jl)
- Integration with [CRRao.jl](https://github.com/xKDR/CRRao.jl) for regressions, with design based standard errors. 
- Integration with [GLM.jl](https://github.com/JuliaStats/GLM.jl)
- Support and speedups with [CategoricalsArrays](https://github.com/JuliaData/CategoricalArrays.jl)
- Association and likelihood ratio tests
- Support for [imputing missing data](https://stat.ethz.ch/CRAN/web/packages/mitools/index.html)
- Bayesian surveys

## References

[^1]: [Thomas Lumley Homepage](https://www.stat.auckland.ac.nz/people/tlum005)
[^2]: [Makie project](https://docs.makie.org/stable/)
[^3]: [DataFrames.jl](https://dataframes.juliadata.org/stable/) 
[^4]: [Turing](https://turing.ml/stable/)
[^5]: Discussion on discourse posts in [August](https://discourse.julialang.org/t/suggestions-for-the-design-of-survey-jl/86381) and [April](https://discourse.julialang.org/t/pushing-julia-statistics-development/80111) 2022.
[^6]: [Optim.jl](https://julianlsolvers.github.io/Optim.jl/stable/)
[^7]: Ben Schneider [blog post](https://www.practicalsignificance.com/posts/making-the-survey-package-run-100x-faster/) on how to use RCpp to make `survey` faster
[^8]: Julia Discourse posts [here](https://discourse.julialang.org/t/any-package-for-survey-data-analysis/67317) and [here](https://discourse.julialang.org/t/analysis-of-complex-surveys-in-julia/44011) 
[^9]: [samplics/survey.jl](https://github.com/samplics-org/survey.jl) and [jamanrique/SurveyAnalysis.jl](https://github.com/jamanrique/SurveyAnalysis.jl).
[^10]: Alan Zaslavsky keeps a comprehensive [list](https://www.hcp.med.harvard.edu/statistics/survey-soft/) of survey analysis software for the ASA Section on Survey Research Methods.
[^11]: Stack exchange [discussion](https://stackoverflow.com/questions/35210712/methods-in-r-for-large-complex-survey-data-sets) of other people with similar stories.
[^12]: [R survey package](https://cran.r-project.org/web/packages/survey/index.html)
[^13]: [Domesticating survey data](https://dicook.github.io/WOMBAT/slides/thomas.pdf)