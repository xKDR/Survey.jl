# [Generalized Linear Models in Survey](@id manual)

The `svyglm()` function in the Julia Survey package is used to fit generalized linear models (GLMs) to survey data. It incorporates survey design information, such as sampling weights, stratification, and clustering, to produce valid estimates and standard errors that account for the type of survey design.

As of June 2023, the [GLM.jl documentation](https://juliastats.org/GLM.jl/stable/) lists the supported distribution families and their link functions as:
```txt
Bernoulli (LogitLink)
Binomial (LogitLink)
Gamma (InverseLink)
InverseGaussian (InverseSquareLink)
NegativeBinomial (NegativeBinomialLink, often used with LogLink)
Normal (IdentityLink)
Poisson (LogLink)
```

Refer to the GLM.jl documentation for more information about the GLM package.

## Fitting a GLM to a Survey Design object

You can fit a GLM to a Survey Design object the same way you would fit it to a regular data frame. The only difference is that you need to specify the survey design object as the second argument to the svyglm() function.

```julia
using Survey
apisrs = load_data("apisrs") 

# Simple random sample survey
srs = SurveyDesign(apisrs, weights = :pw) 

# Survey stratified by stype
dstrat = SurveyDesign(apistrat, strata = :stype, weights = :pw) 

# Survey clustered by dnum
dclus1 = SurveyDesign(apiclus1, clusters = :dnum, weights = :pw) 
```

Once you have the survey design object, you can fit a GLM using the svyglm() function. Specify the formula for the model and the distribution family. 

The svyglm() function supports all distribution families supported by GLM.jl, i.e. Bernoulli, Binomial, Gamma, Geometric, InverseGaussian, NegativeBinomial, Normal, and Poisson. 

For example, to fit a GLM with a Bernoulli distribution and a Logit link function to the `srs` survey design object we created above:
```julia
formula = @formula(api00 ~ api99)
my_glm = svyglm(formula, srs, family = Normal())

# View the coefficients and standard errors
my_glm.Coefficients
my_glm.SE
```

## Examples

The examples below use the `api` datasets, which contain survey data collected about California schools. The datasets are included in the Survey.jl package and can be loaded by calling `load_data("name_of_dataset")`.

### Bernoulli with Logit Link

A school being eligible for the awards program (`awards`) is a binary outcome (0 or 1). Let's assume it follows a Bernoulli distribution. Suppose we want to predict `awards` based on the percentage of students eligible for subsidized meals (`meals`) and the percentage of English Language Learners (`ell`). We can fit this GLM using the code below:

```julia
using Survey
apisrs = load_data("apisrs")
srs = SurveyDesign(apisrs, weights = :pw) 

# Convert yes/no to 1/0
apisrs.awards = ifelse.(apisrs.awards .== "Yes", 1, 0)

# Fit the model
model = glm(@formula(awards ~ meals + ell), apisrs, Bernoulli(), LogitLink())
```

### Binomial with Logit Link

Let us assume that the number of students tested (`api_stu`) follows a Binomial distribution, which models the number of successes out of a fixed number of trials. Suppose we want to predict the number of students tested based on the percentage of students eligible for subsidized meals (`meals`) and the percentage of English Language Learners (`ell`). We can fit this GLM using the code below:

```julia
using Survey
apisrs = load_data("apisrs")
srs = SurveyDesign(apisrs, weights = :pw) 

# Rename api.stu to api_stu
rename!(apisrs, Symbol("api.stu") => :api_stu)

# Normalize api_stu
apisrs.api_stu = apisrs.api_stu ./ sum(apisrs.api_stu)

# Fit the model
model = glm(@formula(api_stu ~ meals + ell), apisrs, Binomial(), LogitLink())
```

### Gamma with Inverse Link

Let us assume that the average parental education level (`avg_ed`) follows a Gamma distribution, which is suitable for modeling continuous, positive-valued variables with a skewed distribution. Suppose we want to predict the average parental education level based on the percentage of students eligible for subsidized meals (`meals`) and the percentage of English Language Learners (`ell`). We can fit this GLM using the code below:

```julia
using Survey
apisrs = load_data("apisrs")
srs = SurveyDesign(apisrs, weights = :pw) 

# Rename api.stu to api_stu
rename!(apisrs, Symbol("avg.ed") => :avg_ed)

# Fit the model
model = glm(@formula(avg_ed  ~ meals + ell), apisrs, Gamma(), InverseLink())
```

### More examples

Other examples for GLMs can be found in the [GLM.jl documentation](https://juliastats.org/GLM.jl/stable/).