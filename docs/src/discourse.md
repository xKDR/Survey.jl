# Discourse post
Hi everyone,

We are pleased to announce registeration of [Survey.jl](https://github.com/xKDR/Survey.jl) for analysis of complex surveys. 

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

### Repository URL: 
GitHub - [xKDR/Survey.jl: Analysis of Complex Surveys](https://github.com/xKDR/Survey.jl)
[Documentation home](https://xkdr.github.io/Survey.jl/dev/)
[Getting started with Survey.jl](https://xkdr.github.io/Survey.jl/dev/getting_started/)
[API reference](https://xkdr.github.io/Survey.jl/dev/api/)
[Comparison with other survey analysis tools](https://xkdr.github.io/Survey.jl/dev/man/comparisons/) - currently has comparison with R

### Future ideas
- Variance by Taylor linearization for `SurveyDesign`
- Support additional replicate weighting algorithms (BRR, Jackknife, other bootstrap flavours) for `ReplicateDesign`
- Support for more complex survey designs
- Post-stratification, raking or calibration, GREG estimation and related methods.
- Code analysis and optimisation
- Contingency table analysis, support for [CategoricalArrays](https://github.com/JuliaData/CategoricalArrays.jl)
- Wrappers and connection with [GLM.jl](https://github.com/JuliaStats/GLM.jl)
- Association and likelihood ratio tests
- Support for [imputing missing data](https://stat.ethz.ch/CRAN/web/packages/mitools/index.html)

# Why a package for survey analysis in Julia?
1. **Performance**: Several software tools are available to analyse complex surveys[^list_packages]. The R [survey](https://r-survey.r-forge.r-project.org/survey/) package is a widely used open-source option, but it excels in **expressivity**, and *performance* was not a key development goal. Performance is one of the key reasons why many applied survey researchers pay for proprietary SAS/Stata solutions. The authors of this package have waited hours/days in R generating summary statistics (especially standard errors) on really large surveys[^stackexchangepost]. Initial prototyping suggested vast speedups for similar analyses in Julia vs R[^julicon_clip]. In particular, we found magnitude of times speedups when using replicate weighting techniques such as bootstrapping for variance estimation[^faster]. In many classes of simulation problems, Julia has a substantial edge over R.
2. **Community interest**: There has been interest in a package for survey analysis in the Julia community for quite some time[^2], and several attempts to create a package, which never materialised[^3]. In the course of development of the pacakage, we received some feedback and even contributing PRs on the project[^community].
3. **Development and maintenance** Julia avoids the two language problem, whereas "fast" frameworks in R or Python usually rely on behind the scenes calls to C/C++/Fortran for speedups, as native interpreted code in those languages is usually slow. While there are addon packages and ways to boost speed[^bschneider], they require high-order programming skills in another "lower level" language. Applied survey researchers just want something that works great out of the box, so a completely Julia-native survey analysis package is great for users as well as long term development and maintenance.

[^julicon_clip]: Survey.jl [clip](https://youtu.be/RY7SSfyNl9o) from Julia Statistics Symposium, JuliaCon 2022
[^community]: discussion on discourse posts in [August](https://discourse.julialang.org/t/suggestions-for-the-design-of-survey-jl/86381) and [April](https://discourse.julialang.org/t/pushing-julia-statistics-development/80111) 2022.
[^faster]: benchmarking article in the works
[^stackexchangepost]: stack exchange [discussion](https://stackoverflow.com/questions/35210712/methods-in-r-for-large-complex-survey-data-sets) of other people with similar stories.
[^bschneider]: Ben Schneider [blog post](https://www.practicalsignificance.com/posts/making-the-survey-package-run-100x-faster/) on how to use RCpp to make `survey` faster
[^2]: Julia Discourse posts [here](https://discourse.julialang.org/t/any-package-for-survey-data-analysis/67317) and [here](https://discourse.julialang.org/t/analysis-of-complex-surveys-in-julia/44011) 
[^3]: [samplics/survey.jl](https://github.com/samplics-org/survey.jl) and [jamanrique/SurveyAnalysis.jl](https://github.com/jamanrique/SurveyAnalysis.jl).
[^list_packages]: Alan Zaslavsky keeps a comprehensive [list](https://www.hcp.med.harvard.edu/statistics/survey-soft/) of survey analysis software for the ASA Section on Survey Research Methods.