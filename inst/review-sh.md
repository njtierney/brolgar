# Response to [Stephanie Hicks](https://www.stephaniehicks.com) review of brolgar (git hash 698406)

Thank you for your thoughtful comments, @stephaniehicks, I will address these below.


## [General Standards](https://ropenscilabs.github.io/statistical-software-review-book/standards.html#general-standards-for-statistical-software)

Applying General Software Standards

### Documentation

- [x] **G1.0** *Statistical Software should list at least one primary reference from published academic literature.* 

Not met as no paper reference in the documentation or package description

#### Statistical Terminology

- [x] **G1.1** *All statistical terminology should be clarified and unambiguously defined.* 
        
As an example, I read through the `vignettes/exploratory-modelling.Rmd` which assumed the user understands what is mean by "fit a model". Other examples of potential concern: "fit a linear model for each group in a dataset", "fit a linear model for each key in the data", "linear model formula" (not sure if all users would know what is meant by 'formula'). 

> Nick: I have altered the first few paragraphs and added a paragraph near "linear model formula" to address this.

Another example is in the `vignettes/longitudinal-data-structures.Rmd`. Potential terminology that could be clarified include: "panel data", "cross-sectional data". 

> Nick: I have altered this sentence slightly, but the intention of this section is to point out that there are many different definitions for these types of data, and to provide a consistent definition that I believe encompasses all of them. Explaining each of these might be a bit tough to do concisely, let me know if you think this is necessary.

#### Function-level Documentation

 - [x] **G1.2a** *All internal (non-exported) functions should also be documented in standard [`roxygen`](https://roxygen2.r-lib.org/) format, along with a final `@noRd` tag to suppress automatic generation of `.Rd` files.* 

e.g. internal functions (non-exported) in `R/utils.R` are not documented. 

> Nick: I have not added documentation for `R/utils.R` and removed functions
not used in the package.

#### Supplementary Documentation

- [x] **G1.3** *Software should include all code necessary to reproduce results which form the basis of performance claims made in associated publications.* 

Unsure about this as I do not see any associated publications? I tried to knit several of the vignettes and I was able to dot that. 

### Input Structures

#### Uni-variate (Vector) Input

- [x] **G2.0** *Provide explicit secondary documentation of any expectations on lengths of inputs (generally implying identifying whether an input is expected to be single- or multi-valued)*

I found at least one example in `monotonics.R` where `@param x numeric or integer` is not specific about the length of the input. 

- [x] **G2.1** *Provide explicit secondary documentation of expectations on data types of all vector inputs (see the above list).*

I found at least one example in `b_summaries.R` where `@param x a vector` does not specify the data type of the vector input. 

- [x] **G2.2** *Appropriately prohibit or restrict submission of multivariate input to parameters expected to be univariate.*

I found at least one example in `facet-sample.R` where I provided a numeric vector of length 2 to the `n_facets` parameter. 
```
library(ggplot2)
ggplot(heights, aes(x = year, y = height_cm, group = country)) +
  geom_line() +
  facet_sample(n_facets=c(2,5))
```

This worked, but resulted in the following warning message. 
```
Warning messages:
1: In seq_len(params$n) : first element used of 'length.out' argument
2: In if (nr.plots <= 3L) c(nr.plots, 1L) else if (nr.plots <= 6L) c((nr.plots +  :
  the condition has length > 1 and only the first element will be used
3: In if (nrow * ncol < n) { :
  the condition has length > 1 and only the first element will be used
4: In seq_len(n_strata) : first element used of 'length.out' argument
```

In the `nearest.R` function, this also worked and gave no warning / error.
```
x <- runif(20)
near_middle(x = x,
            middle = runif(10, 0, 1),
            within = 0.2)
```

- [x] **G2.3** *For univariate character input:*

 - [x] **G2.3b** *Either: use `tolower()` or equivalent to ensure input of character parameters is not case dependent; or explicitly document that parameters are strictly case-sensitive.*

In at least one function, I found missing documentation around case-sensitivity. 

```
index_regular(pisa, Year)
```

resulted in 

```
Error: `distinct()` must use existing variables.
x `Year` not found in `.data`.
Run `rlang::last_error()` to see where the error occurred.
```


#### Missing or Undefined Values

- [x] **G2.10** *Statistical Software should implement appropriate checks for missing data as part of initial pre-processing prior to passing data to analytic algorithms.*

In at least one function, I found missing checks for missing data in rows. This gave no message mentioning mentioning the missing data. 

```
heights_na <- heights
heights_na[1,4] <- NA
keys_near(heights_na, height_cm)
```

- [x] **G2.11** *Where possible, all functions should provide options for users to specify how to handle missing (`NA`) data, with options minimally including:*

Not met. I could not find an options for user-defined NA handling exist.

- [x] **G2.12** *Functions should never assume non-missingness, and should never pass data with potential missing values to any base routines with default `na.rm = FALSE`-type parameters (such as [`mean()`](https://stat.ethz.ch/R-manual/R-devel/library/base/html/mean.html), [`sd()`](https://stat.ethz.ch/R-manual/R-devel/library/stats/html/sd.html) or [`cor()`](https://stat.ethz.ch/R-manual/R-devel/library/stats/html/cor.html)).*

See example above. 

- [x] **G2.13** *All functions should also provide options to handle undefined values (e.g., `NaN`, `Inf` and `-Inf`), including potentially ignoring or removing such values.* 

This returns `Inf` in the values. 

```
heights_na <- heights
heights_na[1,4] <- Inf
keys_near(heights_na, height_cm)
```

### Testing 

#### Test Data Sets

- [x] **G4.0** *Where applicable or practicable, tests should use standard data sets with known properties (for example, the [NIST Standard Reference Datasets](https://www.itl.nist.gov/div898/strd/), or data sets provided by other widely-used R packages).*

Not clear if this is OK, but e.g. `tests/testthat/test-facet-strata.R` uses the `heights` dataset as provided in this package as opposed to "other widely-used R packges".


#### Responses to Unexpected Input

- [x] **G4.2** Appropriate error and warning behaviour of all functions should be explicitly demonstrated through tests. In particular,

 - [x] **G4.2b** Explicit tests should demonstrate conditions which trigger every one of those messages, and should compare the result with expected values.
 
Didn't see this. 

- [ ] **G4.3** For functions which are expected to return objects containing no missing (`NA`) or undefined (`NaN`, `Inf`) values, the absence of any such values in return objects should be explicitly tested. 


#### Algorithm Tests

 - [ ] **G4.8** **Edge condition tests** *to test that these conditions produce expected behaviour such as clear warnings or errors when confronted with data with extreme properties including but not limited to:*
 - [x] **G4.8a** *Zero-length data*
 
e.g. no warning / error given: 

```
> vec_inc <- c()
> length(vec_inc)
[1] 0
> increasing(vec_inc)
[1] TRUE

```
 - [x] **G4.8b** *Data of unsupported types (e.g., character or complex numbers in for functions designed only for numeric data)*

No error / warning given for an unsupported data type:

```
> vec_inc <- c("a", "b", "c")
> increasing(vec_inc)
Error in r[i1] - r[-length(r):-(length(r) - lag + 1L)] : 
  non-numeric argument to binary operator
```

 - [x] **G4.8c** *Data with all-`NA` fields or columns or all identical fields or columns*

e.g. 

```
> vec_inc <- c(NA, NA, NA)
> increasing(vec_inc)
[1] NA
```

- [x] **G4.9** **Noise susceptibility tests** *Packages should test for expected stochastic behaviour, such as through the following conditions:*
 - [x] **G4.9a** *Adding trivial noise (for example, at the scale of `.Machine$double.eps`) to data does not meaningfully change results*
 
Didn't see this

 - [x] **G4.9b** *Running under different random seeds or initial conditions does not meaningfully change results* 
 
Didn't see this, but also don't expect it to change much. 

---

## [EDA Standards](https://ropenscilabs.github.io/statistical-software-review-book/standards.html#exploratory-data-analysis)

### Documentation Standards

- [x] **EA1.0** *Identify one or more target audiences for whom the software is intended*

Didn't see this explicitly mentioned. 

- [x] **EA1.2** *Identify the kinds of questions the software is intended to help explore; for example, are these questions:* - *inferential?* - *predictive?* - *associative?* - *causal?* - *(or other modes of statistical enquiry?)* 

The plotting functions seem pretty exploratory / associative, but not explicitly mentioned. Though the plotting functions are also useful for exploring modeling results (i.e. more inferential). 

### Visualization and Summary Output

- [x] **EA5.0** *Graphical presentation in EDA software should be as accessible as possible or practicable. In particular, EDA software should consider accessibility in terms of:*
 - [x] **EA5.0b** Default colour schemes should be carefully constructed to ensure accessibility.*
 
Default ggplot2, but this can be altered by the user. 

#### General Standards for Visualization (Static and Dynamic)

- [x] **EA5.4** *All visualisations should include units on all axes, with sensibly rounded values (for example, as produced by the `pretty()` function).* 

Again, just relying on ggplot2 here. 

### Testing

#### Graphical Output

- [x] **EA6.1** The properties of graphical output from EDA software should be explicitly tested, for example via the [`vdiffr` package](https://github.com/r-lib/vdiffr) or equivalent. 

Didn't see this? 

---

## [Time Series Standards](https://ropenscilabs.github.io/statistical-software-review-book/standards.html#time-series-software)


As this package focuses on longitudinal data (e.g. panel data, cross-sectional data, and time series), I struggled to apply the Time Series Standards only because the functions are meant to be broader than just time series.  So I decided to remove it as one of the standards. Happy to discuss and loop back to this though. 