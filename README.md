
<!-- README.md is generated from README.Rmd. Please edit that file -->

# brolgar (BRowse over Longitudinal data Graphically and Analytically in R)

<!-- badges: start -->

[![Travis build
status](https://travis-ci.org/tprvan/brolgar.svg?branch=master)](https://travis-ci.org/tprvan/brolgar)
[![AppVeyor build
status](https://ci.appveyor.com/api/projects/status/github/tprvan/brolgar?branch=master&svg=true)](https://ci.appveyor.com/project/tprvan/brolgar)
[![Codecov test
coverage](https://codecov.io/gh/tprvan/brolgar/branch/master/graph/badge.svg)](https://codecov.io/gh/tprvan/brolgar?branch=master)
[![Travis build
status](https://travis-ci.org/njtierney/brolgar.svg?branch=master)](https://travis-ci.org/njtierney/brolgar)
[![AppVeyor build
status](https://ci.appveyor.com/api/projects/status/github/njtierney/brolgar?branch=master&svg=true)](https://ci.appveyor.com/project/njtierney/brolgar)
[![Codecov test
coverage](https://codecov.io/gh/njtierney/brolgar/branch/master/graph/badge.svg)](https://codecov.io/gh/njtierney/brolgar?branch=master)
<!-- badges: end -->

Exploring longitudinal data can be challenging. For example, when there
are many individuals it is difficult to look at all of them, as you
often get a “plate of spaghetti” plot, with many lines plotted on top of
each other.

``` r
library(brolgar)
library(ggplot2)
ggplot(wages, 
       aes(x = exper, 
             y = lnw, 
             group = id)) + 
  geom_line()
```

<img src="man/figures/README-show-spaghetti-1.png" width="100%" />

These are hard to interpret.

You might then want to explore those individuals with higher amounts of
variation, or those with lower variation. But calculating this for
individuals draws you away from your analysis, and instead you are now
wrangling with a different problem: summarising key information about
each individual and incorporating that back into the data.

This is annoying, and distracts from your analysis, inviting errors.

**brolgar** (BRowse over Longitudinal data Graphically and Analytically
in R) (forked from <https://github.com/tprvan/brolgar>) provides tools
for providing statistical summaries for each individual. These are
referred to as a **longnostics**, a portmanteau of **long**itudinal and
**cognostic**. These **longnostics** make it straightforward to extract
subjects with certain properties to gain some insight into the data.

## Installation

Install from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("tprvan/brolgar")
```

## What is longitudinal data?

Longitudinal data has subjects who are measured on several
characteristics repeatedly through time but not always at the same time
points or the same number of times.

## Example usage

Let’s extract informative individual patterns by concentrating on
different statistics. A story can be woven that may be relevant rather
than speaking in generalities.

The **wages** data set analysed in Singer & Willett (2003) will be used
to demonstrate some of the capabilities of this package.

``` r
library(brolgar)
library(tibble)
data(wages)
wages
#> # A tibble: 6,402 x 15
#>       id   lnw exper   ged postexp black hispanic   hgc hgc.9 uerate  ue.7
#>    <int> <dbl> <dbl> <int>   <dbl> <int>    <int> <int> <int>  <dbl> <dbl>
#>  1    31  1.49 0.015     1   0.015     0        1     8    -1   3.21 -3.78
#>  2    31  1.43 0.715     1   0.715     0        1     8    -1   3.21 -3.78
#>  3    31  1.47 1.73      1   1.73      0        1     8    -1   3.21 -3.78
#>  4    31  1.75 2.77      1   2.77      0        1     8    -1   3.3  -3.70
#>  5    31  1.93 3.93      1   3.93      0        1     8    -1   2.89 -4.11
#>  6    31  1.71 4.95      1   4.95      0        1     8    -1   2.49 -4.50
#>  7    31  2.09 5.96      1   5.96      0        1     8    -1   2.6  -4.40
#>  8    31  2.13 6.98      1   6.98      0        1     8    -1   4.8  -2.20
#>  9    36  1.98 0.315     1   0.315     0        0     9     0   4.89 -2.10
#> 10    36  1.80 0.983     1   0.983     0        0     9     0   7.4   0.4 
#> # … with 6,392 more rows, and 4 more variables: ue.centert1 <dbl>,
#> #   ue.mean <dbl>, ue.person.cen <dbl>, ue1 <dbl>
```

### Available `longnostics`

The `longnostics` in `brolgar` all start with `l_`, and *for all
individuals in the data* calculate a statistic for each individual
(specified with an `id`), for some specified variable:

  - `l_n_obs()` Number of observations
  - `l_min()` Minimum
  - `l_max()` Maximum
  - `l_mean()` Mean
  - `l_diff()` Lagged difference (by default, the first order
    difference)
  - `l_q1()` First quartile
  - `l_median()` Median value
  - `l_q3()` Third quartile
  - `l_sd()` Standard deviation
  - `l_slope()` Slope and intercept (given some linear model formula)

For example, we can calculate the number of observations with
`l_n_obs()`:

``` r
wages_nobs <- l_n_obs(data = wages,
        id = id,
        var = lnw)

wages_nobs
#> # A tibble: 888 x 2
#>       id l_n_obs
#>    <int>   <int>
#>  1    31       8
#>  2    36      10
#>  3    53       8
#>  4   122      10
#>  5   134      12
#>  6   145       9
#>  7   155      11
#>  8   173       6
#>  9   206       3
#> 10   207      11
#> # … with 878 more rows
```

Which could be further summarised to get a sense of the range of the
data:

``` r
library(dplyr)
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union
library(ggplot2)
ggplot(wages_nobs,
       aes(x = l_n_obs)) + 
  geom_bar()
```

<img src="man/figures/README-summarise-n-obs-1.png" width="100%" />

``` r

summary(wages_nobs$l_n_obs)
#>    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
#>   1.000   5.000   8.000   7.209   9.000  13.000
```

## Identifying an individual of interest

We might be interested in showing the experience and lnw (?), and so
look at a plot like the following:

``` r
ggplot(wages, 
       aes(x = exper, 
             y = lnw, 
             group = id)) + 
  geom_line()
```

<img src="man/figures/README-demo-why-brolgar-1.png" width="100%" />

This is a plate of spaghetti\! It is hard to understand\!

We can use `brolgar` to get the number of observations and slope
information for each individual to identify those that are decreasing
over time.

``` r
sl <- l_slope(wages, id, lnw~exper)
ns <- l_n_obs(wages, id, lnw)

sl
#> # A tibble: 888 x 3
#> # Groups:   id [888]
#>       id l_intercept l_slope
#>    <int>       <dbl>   <dbl>
#>  1    31        1.41  0.101 
#>  2    36        2.04  0.0588
#>  3    53        2.29 -0.358 
#>  4   122        1.93  0.0374
#>  5   134        2.03  0.0831
#>  6   145        1.59  0.0469
#>  7   155        1.66  0.0867
#>  8   173        1.61  0.100 
#>  9   206        1.73  0.180 
#> 10   207        1.62  0.0884
#> # … with 878 more rows
ns
#> # A tibble: 888 x 2
#>       id l_n_obs
#>    <int>   <int>
#>  1    31       8
#>  2    36      10
#>  3    53       8
#>  4   122      10
#>  5   134      12
#>  6   145       9
#>  7   155      11
#>  8   173       6
#>  9   206       3
#> 10   207      11
#> # … with 878 more rows
```

We can then join these summaries back to the data:

``` r
wages_lg <- wages %>%
  left_join(sl, by = "id") %>%
  left_join(ns, by = "id")

wages_lg
#> # A tibble: 6,402 x 18
#>       id   lnw exper   ged postexp black hispanic   hgc hgc.9 uerate  ue.7
#>    <int> <dbl> <dbl> <int>   <dbl> <int>    <int> <int> <int>  <dbl> <dbl>
#>  1    31  1.49 0.015     1   0.015     0        1     8    -1   3.21 -3.78
#>  2    31  1.43 0.715     1   0.715     0        1     8    -1   3.21 -3.78
#>  3    31  1.47 1.73      1   1.73      0        1     8    -1   3.21 -3.78
#>  4    31  1.75 2.77      1   2.77      0        1     8    -1   3.3  -3.70
#>  5    31  1.93 3.93      1   3.93      0        1     8    -1   2.89 -4.11
#>  6    31  1.71 4.95      1   4.95      0        1     8    -1   2.49 -4.50
#>  7    31  2.09 5.96      1   5.96      0        1     8    -1   2.6  -4.40
#>  8    31  2.13 6.98      1   6.98      0        1     8    -1   4.8  -2.20
#>  9    36  1.98 0.315     1   0.315     0        0     9     0   4.89 -2.10
#> 10    36  1.80 0.983     1   0.983     0        0     9     0   7.4   0.4 
#> # … with 6,392 more rows, and 7 more variables: ue.centert1 <dbl>,
#> #   ue.mean <dbl>, ue.person.cen <dbl>, ue1 <dbl>, l_intercept <dbl>,
#> #   l_slope <dbl>, l_n_obs <int>
```

We can then highlight those individuals with more than 5 obserations,
and highlight those with a negative slope using `gghighlight`:

``` r
library(gghighlight)

wages_lg %>% 
  filter(l_n_obs > 5) %>%
  ggplot(aes(x = exper, 
             y = lnw, 
             group = id)) + 
  geom_line() +
  gghighlight(l_slope < (-0.5),
              use_direct_label = FALSE)
```

<img src="man/figures/README-use-gg-highlight-1.png" width="100%" />

# A Note on the API

This version of brolgar has been forked from
[tprvan/brolgar](https://github.com/tprvan/brolgar), and is undergoing
breaking changes to the API.
