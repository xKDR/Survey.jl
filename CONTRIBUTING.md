[![ColPrac: Contributor's Guide on Collaborative Practices for Community Packages](https://img.shields.io/badge/ColPrac-Contributor's%20Guide-blueviolet)](https://github.com/SciML/ColPrac)

# Contributing to Survey.jl

  * [Overview](#overview)
  * [Reporting Issues](#reporting-issues)
  * [Recommended workflow setup](#recommended-workflow-setup)
  * [Modifying an existing docstring in `src/`](#modifying-an-existing-docstring-in--src--)
  * [Adding a new docstring to `src/`](#adding-a-new-docstring-to--src--)
  * [Doctests](#doctests)
  * [Integration with exisiting API](#integration-with-exisiting-api)
  * [Contributing](#contributing)
  * [Style Guidelines](#style-guidelines)
  * [Git Recommendations For Pull Requests](#git-recommendations-for-pull-requests)

## Overview
Thank you for thinking about making contributions to Survey.jl!  
We aim to keep consistency in contribution guidelines to DataFrames.jl, which is the main upstream dependency for the project. 
Reading through the ColPrac guide for collaborative practices is highly recommended for new contributors. The following are extra guidelines and some  clarifications used on the `DataFrames` project, with small additions specific to Survey.jl.

## Reporting Issues

* It's always good to start with a quick search for an existing issue to post on,
  or related issues for context, before opening a new issue
* Including minimal examples is greatly appreciated
* If it's a bug, or unexpected behaviour, reproducing on the latest development version
  (`Pkg.add(name="Survey", rev="main")`) is a good gut check and can streamline the process,
  along with including the first two lines of output from `versioninfo()`

## Setting up development workflow

Below tutorial uses Windows Subsystem for Linux (WSL) and VSCode. Linux/MacOS/BSD can ignore WSL specific steps.

1. Install Ubuntu on WSL from the [Ubuntu website](https://ubuntu.com/wsl) or the Microsoft Store
2. Create a fork of the [Survey.jl repository](https://github.com/xKDR/Survey.jl). You will only be ever working on this fork, and submitting Pull Requests to the main repo. 
3. Copy the SSH link from your fork by clicking the green `<> Code` icon and then `SSH`. 
    - You must already have SSH setup for this to work. If you don't, look up a tutorial on how to clone a github repository using SSH.
4. Open a WSL terminal, and run :
    - `curl -fsSL https://install.julialang.org | sh`
    - `git clone git@github.com:your_username/Survey.jl.git` -- replace "*your_username**"
    - `julia`
3. You are now in the Julia REPL, run :
    - `import Pkg; Pkg.add("Revise")`
    - `import Pkg; Pkg.add("Survey")`
    - `import Pkg; Pkg.add("Test")`
    - `] dev .`
4. Open VSCode and install the following extensions :
    - WSL 
    - Julia
5. Go back to your WSL terminal, navigate to the folder of your repo, and run `code .` to open VSCode in that folder
6. Create a `dev` folder (only if you want, it is gitignored by default), and a `test.jl` file in the file. Paste this block of code and save :

```julia
using Revise, Survey, Test

@testset "ratio.jl" begin
    apiclus1 = load_data("apiclus1")
    dclus1 = SurveyDesign(apiclus1; clusters=:dnum, strata=:stype, weights=:pw)
    @test ratio(:api00, :enroll, dclus1).ratio[1] ≈ 1.17182 atol = 1e-4
end
```

9. In the WSL terminal (not Julia REPL), run `julia dev/test.jl`  
✅ If you get no errors, your setup is now complete !

You can keep working in the `dev` folder, which is .gitignored.  
Once you have working code and tests, you can move them to the appropriate folders, commit, push, and submit a Pull Request.  
Make sure to read the rest of this document so you can learn the best practices and guidelines for this project.  

## Modifying an existing docstring in `src/`

All docstrings are written inline above the methods or types they are associated with and can
be found by clicking on the `source` link that appears below each docstring in the documentation.
The steps needed to make a change to an existing docstring are listed below:

* Create a new branch;
* Find the docstring in `src/`;
* Update the text in the docstring;
* run `julia make.jl` from the `/docs` directory;
* check the output in `doc/_build/html/` to make sure the changes are correct;
* commit your changes and open a pull request.
* a preferred structure of docstring for a function is:
  + list of accepted signatures;
  + a short information what function does;
  + description of its arguments;
  + additional details if needed;
  + examples.

## Adding a new docstring to `src/`

The steps required to add a new docstring are listed below:
* find a suitable object definition in `src/` that the docstring
  will be most applicable to;
* add a doctring above the definition;
* find a suitable `@docs` code block in the `docs/src/lib/functions.md` file 
  where you would like the docstring to appear; (if the docstring is added
  to an object that is not exported add it to `docs/src/lib/internals.md`);
* add the name of the definition to the `@docs` code block. For example, with a docstring
  added to a function `bar`.
```
"..."
function bar(args...)
    # ...
end
```

you would add the name `bar` to a `@docs` block in `docs/src/lib/functions.md`
````
```@docs
foo
bar # <-- Added this one.
baz
```
````

* run `julia make.jl` from the `/docs` directory;
* check the output in `docs/_build/html` to make sure the changes are correct;
* commit your changes and open a pull request.

## Doctests

Examples written within docstrings can be used as test cases known as *doctests* by annotating code 
blocks with `jldoctest`:
````
```jldoctest
julia> uppercase("Docstring test")
"DOCSTRING TEST"
```
````
A doctest needs to match an interactive REPL including the `julia>` prompt. To run 
doctests run `julia make.jl` from the `/docs` directory.

It is recommended to add the header `# Examples` above the doctests.

## Integration with exisiting API
One of ways to integrate your contributions with the existing API is by adding multiple dispatch functions. 

Say you want to add design coefficients, or confidence intervals to existing summary statistics functions, like `mean` and `total`.
You can write a function which calculates the CI given inputs in a file called `ci.jl`. You can then add a new definition of `mean` in `mean.jl`. This calls the original `mean` function which returns the estimate and SE. You `ci` function takes these as inputs and returns another dataframe with `ci_lower` and `ci_upper` added as columns in the returning dataframe.

This way you are modifying as little as possible of previously written code, and integrating your functionality into the API with least frictions. Docstring and doctests can also simply be written with your additional multiple dispatch function.

## Contributing
* Codedev coverage has reached 100%. So please make sure to add testing cases of contributed code to keep it at 100%.
* If you want to propose a new functionality it is strongly recommended to open an issue first and reach a decision on the final design.
  Then a pull request serves an implementation of the agreed way how things should work.
* If you are a new contributor and would like to get a guidance on what area
  you could focus your first PR please do not hesitate to ask community members
  will help you with picking a topic matching your experience.
* Feel free to open, or comment on, an issue and solicit feedback early on,
  especially if you're unsure about aligning with design goals and direction,
  or if relevant historical comments are ambiguous.
* Pair new functionality with tests, and bug fixes with tests that fail pre-fix.
  Increasing test coverage as you go is always nice.
* Aim for atomic commits, if possible, e.g. `change 'foo' behavior like so` &
  `'bar' handles such and such corner case`,
  rather than `update 'foo' and 'bar'` & `fix typo` & `fix 'bar' better`.
* Pull requests are tested against release branches of Julia,
  so using `Pkg.test("Survey")` as you develop can be helpful.
* The style guidelines outlined below are not the personal style of most contributors,
  but for consistency throughout the project, we've adopted them.
* If a PR adds a new exported name then make sure to add a docstring for it and
  add a reference to it in the documentation.
* A PR with breaking changes should have `[BREAKING]` as a first part of its name.
* A PR which is still draft or work in progress should have `WIP:` as a first part of its name.
* If you make a PR please try to avoid pushing many small commits to GitHub in a sequence as each such commit triggers a separate CI job, which takes compuational time, and not a good use of the small pool of CI resources.

## Style Guidelines

* Include spaces
    + After commas
    + Around operators: `=`, `<:`, comparison operators, and generally around others
    + But not after opening parentheses or before closing parentheses
* Use four spaces for indentation (test data files and Makefiles excepted)
* Don't leave trailing whitespace at the end of lines
* Don't go over the 79 per-line character limit
* Avoid squashing code blocks onto one line, e.g. `for foo in bar; baz += qux(foo); end`
* Don't explicitly parameterize types unless it's necessary
* Never leave things without type qualifications. Use an explicit `::Any`.
* Order method definitions from most specific to least specific type constraints
* Always include a digit after decimal when writing a float, e.g. `[1.0, 2.0]`
  rather than `[1., 2.]`
* In docstrings, optional arguments, including separators and spaces, are surrounded by brackets,
  e.g. `mymethod(required[, optional1[, optional2] ]; kwargs...)`

## Git Recommendations For Pull Requests

* Avoid working from the `main` branch of your fork, creating a new branch will make it
  easier if DataFrames.jl `main` branch changes and you need to update your pull request;
* All PRs and issues should be opened against the `main` branch not against the current release;
* Run tests of your code before sending any commit to GitHub. Only push changes when 
  the tests of the change are passing locally. In particular note that it is not a problem
  if you send several commits in one push command to GitHub as CI will be run only once then;
* If any conflicts arise due to changes in DataFrames.jl `main` branch, prefer updating your pull
  request branch with `git rebase` (rather than `git merge`), since the latter will introduce a merge 
  commit that might confuse GitHub when displaying the diff of your PR, which makes your changes more 
  difficult to review. Alternatively use conflict resolution tool available at GitHub;
* Please try to use descriptive commit messages to simplify the review process;
* Using `git add -p` or `git add -i` can be useful to avoid accidentally committing unrelated changes;
* Maintainers get notified of all changes made on GitHub. However, what is useful is writing a short
  message after a sequence of changes is made summarizing what has changed and that the PR is ready
  for a review;
* When linking to specific lines of code in discussion of an issue or pull request, hit the `y` key
  while viewing code on GitHub to reload the page with a URL that includes the specific commit that 
  you're viewing. That way any lines of code that you refer to will still be correct in the future, even 
  if additional commits are pushed to the branch you are reviewing;
* Please make sure you follow the code formatting guidelines when submitting a PR;
  Also preferably do not modify parts of code that you are not editing as this makes
  reviewing the PR harder (it is better to open a separate maintenance PR
  if e.g. code layout can be improved);
* If a PR is not finished yet and should not be reviewed yet then it should be opened as DRAFT 
  (in this way maintainers will know that they can ignore such PR until it is made non-draft or the author
  asks for a review).
