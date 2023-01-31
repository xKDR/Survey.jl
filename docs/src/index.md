```@meta
CurrentModule = Survey
```

# Survey

This package is used to study complex survey data. It aims to provide a very efficient computing framework for survey analysis, and be a faster alternative to the `survey` package ecosystem in R developed by Prof Thomas Lumley[^lumley].

Surveys are a standard tool for empirical research in social and behavioural sciences, and also widely used by governments and businesses alike. The rapidly growing sizes of survey datasets requires a 

# Why a package for survey analysis in Julia?
Several software tools are available to analyse complex surveys[^list_packages]. The R [survey](https://r-survey.r-forge.r-project.org/survey/) package is a widely used open-source option, but while it excels in expressivity, it's not very performant as it's completely written in R. Generating summary statistics on really large surveys sometimes takes hours.

There has been interest in a package for survey analysis in the Julia community for quite some time[^2], and some attempts to create a package as well[^3].

[^R_survey]: [R survey package](https://cran.r-project.org/web/packages/survey/index.html)
[^lumley]: [Thomas Lumley Homepage](https://www.stat.auckland.ac.nz/people/tlum005)
[^list_packages]: Alan Zaslavsky keeps a comprehensive [list](https://www.hcp.med.harvard.edu/statistics/survey-soft/) of survey analysis software for the ASA Section on Survey Research Methods.

[^2]: see Julia Discourse posts [here](https://discourse.julialang.org/t/any-package-for-survey-data-analysis/67317) and [here](https://discourse.julialang.org/t/analysis-of-complex-surveys-in-julia/44011) 

[^3]: see [samplics](https://github.com/samplics-org/survey.jl) and [jamanrique](https://github.com/jamanrique/SurveyAnalysis.jl).

Complex surveys involve clustering, stratification, unequal probability sampling or a combination of these.

and Julia language is able to provide a high-level interface while  desired 

Surveys are getting larger and more complex in their design. Packages designed for their analysis have not been able to keep with the increasing complexities. For instance, several survey analysis routines used in our organisation (based on R `survey`) take hours to compute


