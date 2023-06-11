# [Generalized Linear Models in Survey](@id manual)

The `svyglm()` function in the Julia Survey package is used to fit generalized linear models (GLMs) to survey data. It incorporates survey design information, such as sampling weights, stratification, and clustering, to produce valid estimates and standard errors that account for the type of survey design.

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

The svyglm() function supports various distribution families, including Bernoulli, Binomial, Gamma, Geometric, InverseGaussian, NegativeBinomial, Normal, and Poisson. 

For example, to fit a GLM with a Bernoulli distribution and a Logit link function to the `srs` survey design object we created above:
```julia
formula = @formula(api00 ~ api99)
my_glm = svyglm(formula, srs, family = Normal())

# View the coefficients and standard errors
my_glm.Coefficients
my_glm.SE
```

## Examples with other distribution families

Bernoulli or Binomial distribution, with logit link:
```julia
using Survey
dat = load_data("binary")
srs = SurveyDesign(dat, weights = :weights)
bernoulli = svyglm(@formula(admit ~ gre + gpa), srs, family = Bernoulli())
binomial = svyglm(@formula(success ~ treatment + age), srs, family = Binomial())
```

Bernoulli (LogitLink)
Binomial (LogitLink)
Gamma (InverseLink)
Geometric (LogLink)
InverseGaussian (InverseSquareLink)
NegativeBinomial (NegativeBinomialLink, often used with LogLink)
Normal (IdentityLink)
Poisson (LogLink)

