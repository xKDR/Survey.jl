# Discourse post
Hi everyone,

We are pleased to announce registeration of [Survey.jl](https://github.com/xKDR/Survey.jl) for analysis of complex surveys. 

Current feature highlights include:
- Data structures for survey manipulation and analysis, based on the fantastic [DataFrames.jl](https://dataframes.juliadata.org/stable/) API.
- Summary statistics such as `mean`, `total`, `ratio` and `quantile` for whole of sample as well as domains.
- Variance estimation using replicate weighting techniques (current default Rao-Wu bootstrap)
- Single stage approximation of multistage sampling schemes
- Common graphical analysis functions using [AlgebraOfGraphics](https://github.com/MakieOrg/AlgebraOfGraphics.jl) backend
- Inspired by the familiar R [survey](https://r-survey.r-forge.r-project.org/survey/) package.

Other highlights include:
- Easily enhancible to other replicate methods
- Actively developed and maintained
- Substatially faster than R `survey` for same functionalities (benchmarking article in the works)

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
- Contingency tables analysis
- Association and likelihood ratio tests
- Support for [imputing missing data](https://stat.ethz.ch/CRAN/web/packages/mitools/index.html)

# Why a package for Survey analysis in Julia?
There has been interest in a package for survey analysis in the Julia community for quite some time [ref here](yolo). 
Surveys are getting larger and more complex in their design. Packages designed for their analysis have not been able to keep with the increasing complexities. For instance, several survey analysis routines used in our organisation (based on R `survey`) take hours to compute

, whereas using Julia

 Our interest in developing a fast package in Julia came from waiting on R `survey` scripts for several hours to obtain  For exampl

- Promoting code reuse by using widely used and tested `DataFrame` at it’s core to allow powerful data manipulation functions while itself being lightweight.


## Draft text

a. there is a class of problems where simulation is the best method. Describe these. Here, the Julia package is fully ready, and it's much faster than the R. 

b. And then, there are problems where analytical solutions are fine. Here you can Julia but it's slow and generally you will be better off with Rcall(). But we have laid the software engineering foundations for the right developmental work. We have showed the roadmap for where to go next. 

The inspiration for the package came from the corresponding R survey package 5 created by Thomas Lumley.