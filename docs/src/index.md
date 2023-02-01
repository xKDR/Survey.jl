```@meta
CurrentModule = Survey
```

# Survey

This package is used to study complex survey data. It aims to provide a very efficient computing framework for survey analysis, and be a faster alternative to the `survey` package ecosystem in R developed by Prof Thomas Lumley[^lumley].

Surveys are a standard tool for empirical research in social and behavioural sciences, and also widely used by governments and businesses alike. In order to get a better representation or more precise estimates, complex surveys use sophisticated sampling techniques like clustering, stratification, unequal probability selection or a combination of these. Computing population estimates from a survey is not as simple as `mean(x)`, and requires several corrections, weights calibrations and adjustments, wherein stems the need for a "survey" package which automatically applies these mathematical techniques. Size of survey datasets has been slowly increasing over the past few decades with advances in computing power and storage, as well as ease of administering surveys online over longer distances and wider geographic areas. The rapidly growing sizes of survey datasets requires an efficient computing system. 

# Highlights
Current feature highlights include:
- Data structures for survey manipulation and analysis, based on the fantastic [DataFrames.jl](https://dataframes.juliadata.org/stable/) API.
- Summary statistics such as `mean`, `total`, `ratio` and `quantile` for whole of sample as well as subpopulations/domains.
- Variance estimation using replicate weighting techniques (current default Rao-Wu bootstrap)
- Single stage approximation of multistage sampling schemes
- Common graphical analysis functions using [AlgebraOfGraphics](https://github.com/MakieOrg/AlgebraOfGraphics.jl) backend
- Inspired by the familiar R [survey](https://r-survey.r-forge.r-project.org/survey/) and related package interface in the R ecosystem.

Other highlights include:
- Easily enhancible to other replicate methods
- Actively developed and maintained
- Substatially faster than R `survey` for same functionalities (benchmarking article in the works)
- Promoting code reuse by using widely used and tested `DataFrame` as the backbone.

# Why a package for survey analysis in Julia?
1. **Performance with expressivity**: Julia is able to combine the **expressivity** of R/Python with the **speed** of a systems programming language, so it is ideally placed to be the foundation for a survey analysis framework. 
   1. Several software tools are available to analyse complex surveys[^list_packages]. The R [survey](https://r-survey.r-forge.r-project.org/survey/) package is a widely used open-source option, but it excels in **expressivity**, and *performance* was not a key development goal. Performance is one of the key reasons why many applied survey researchers pay for proprietary SAS/Stata solutions. The authors of this package have waited hours/days in R generating summary statistics (especially standard errors) on really large surveys[^stackexchangepost]. 
   2. Initial prototyping in Julia suggested vast speedups for similar analyses vs R[^julicon_clip]. In particular, we found magnitude of times speedups when using replicate weighting techniques such as bootstrapping for variance estimation[^faster]. In many classes of simulation problems, Julia has a substantial edge over R.
2. **Community interest**: There has been interest in a package for survey analysis in the Julia community for quite some time[^2], and several attempts to create a package, which never materialised[^3]. In the course of development of the pacakage, we received some feedback and even contributing PRs on the project[^community].
3. **Development and maintenance** Julia avoids the two language problem, whereas "fast" frameworks in R or Python usually rely on behind the scenes calls to C/C++/Fortran for speedups, as native interpreted code in those languages is usually slow. While there are addon packages and methods to boost speed[^bschneider], they require high-order programming skills in other "lower level" languages. Applied survey researchers just want something that works great out of the box, so a completely Julia-native survey analysis package is great for users as well as long term development and maintenance.
4. **Statistical ecosystem**: The statistical and data ecosytem of Julia has matured to have substantial statistical computing abilities. `DataFrames` provides the excellent data wrangling and "split-apply-combine" style analytics widely used survey analysis workflows[^dataframes.jl]. `Makie` provides a tightly integrated visualisation backend for graphical analysis of surveys[^makie]. `LinearAlgebra` and `Optim` as well as auto-differentiation libraries provide cutting edge foundations for further statistical modelling and analysis. `Turing` and `Flux` round up the capabilities in bayesian probabilistic programming and deep learning. Building on top of the statistical stack in Julia, `Survey` is complement to and complemented by the entire data ecosystem.

# Plans
We plan for efficient implementations of all the methods in R `survey`. Features for future releases will include:

- Variance by Taylor linearization for `SurveyDesign`
- Support additional replicate weighting algorithms (BRR, Jackknife, other bootstrap flavours) for `ReplicateDesign`
- Support for more complex survey designs
- Post-stratification, raking or calibration, GREG estimation and related methods.
- Code analysis and optimisation
- Contingency table analysis, support for [CategoricalArrays](https://github.com/JuliaData/CategoricalArrays.jl)
- Integration with [CRRao.jl](https://github.com/xKDR/CRRao.jl) for regressions, with design based standard errors. 
- Integration with [GLM.jl](https://github.com/JuliaStats/GLM.jl)
- Support and speedups with [CategoricalsArrays](https://github.com/JuliaData/CategoricalArrays.jl)
- Association and likelihood ratio tests
- Support for [imputing missing data](https://stat.ethz.ch/CRAN/web/packages/mitools/index.html)
- Bayesian surveys

[^makie]: [Makie project](https://docs.makie.org/stable/)
[^dataframes.jl]: [DataFrames.jl](https://dataframes.juliadata.org/stable/) documentation
[^R_survey]: [R survey package](https://cran.r-project.org/web/packages/survey/index.html)
[^lumley]: [Thomas Lumley Homepage](https://www.stat.auckland.ac.nz/people/tlum005)
[^julicon_clip]: Survey.jl [clip](https://youtu.be/RY7SSfyNl9o) from Julia Statistics Symposium, JuliaCon 2022
[^community]: discussion on discourse posts in [August](https://discourse.julialang.org/t/suggestions-for-the-design-of-survey-jl/86381) and [April](https://discourse.julialang.org/t/pushing-julia-statistics-development/80111) 2022.
[^faster]: benchmarking article in the works
[^stackexchangepost]: stack exchange [discussion](https://stackoverflow.com/questions/35210712/methods-in-r-for-large-complex-survey-data-sets) of other people with similar stories.
[^bschneider]: Ben Schneider [blog post](https://www.practicalsignificance.com/posts/making-the-survey-package-run-100x-faster/) on how to use RCpp to make `survey` faster
[^2]: Julia Discourse posts [here](https://discourse.julialang.org/t/any-package-for-survey-data-analysis/67317) and [here](https://discourse.julialang.org/t/analysis-of-complex-surveys-in-julia/44011) 
[^3]: [samplics/survey.jl](https://github.com/samplics-org/survey.jl) and [jamanrique/SurveyAnalysis.jl](https://github.com/jamanrique/SurveyAnalysis.jl).
[^list_packages]: Alan Zaslavsky keeps a comprehensive [list](https://www.hcp.med.harvard.edu/statistics/survey-soft/) of survey analysis software for the ASA Section on Survey Research Methods.