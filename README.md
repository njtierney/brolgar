
<!-- README.md is generated from README.Rmd. Please edit that file -->

# brolgar (BRowse over Longitudinal data Graphically and Analytically in R)

Note: This version of brolgar has been forked from
[tprvan/brolgar](https://github.com/tprvan/brolgar), and is undergoing
breaking changes to the API. <!-- badges: start --> [![Travis build
status](https://travis-ci.org/njtierney/brolgar.svg?branch=master)](https://travis-ci.org/njtierney/brolgar)
[![AppVeyor build
status](https://ci.appveyor.com/api/projects/status/github/njtierney/brolgar?branch=master&svg=true)](https://ci.appveyor.com/project/njtierney/brolgar)
[![Codecov test
coverage](https://codecov.io/gh/njtierney/brolgar/branch/master/graph/badge.svg)](https://codecov.io/gh/njtierney/brolgar?branch=master)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
<!-- badges: end -->

Exploring longitudinal data can be challenging. For example, when there
are many individuals it is difficult to look at all of them, as you
often get a “plate of spaghetti” plot, with many lines plotted on top of
each other.

``` r
library(brolgar)
library(ggplot2)
ggplot(wages_ts, 
       aes(x = xp, 
             y = ln_wages, 
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
# install.packages("remotes")
remotes::install_github("njtierney/brolgar")
```

## What is longitudinal data?

Longitudinal data has subjects who are measured on several
characteristics repeatedly through time but not always at the same time
points or the same number of times.

## Longitudinal data is time series data.

One of the **Big Ideas** in `brolgar` is that longitudinal data is a
time series.

There is a permanent structure to longitudinal data that should be
accounted for. This can be achieved by consider longitudinal data as a
type of *time series* data.

Now, there are many different ways to think about *what your data looks
like*. Longitudinal data is often typically called “panel data”, for
example. I used to always think that “time series” was defined as
something that was by definition “regular” - with equal spacings between
observations. This is actually not the case - you can have both
“regular”, and “irregular” time series. Don’t believe me? Well, take
it up with Professors Rob Hyndman and George Athanasopolous, who say:

> Anything that is observed sequentially over time is a time series.
> (<https://otexts.com/fpp2/data-methods.html>)

If we define longitudinal data as a time series, we gain access to a
suite of nice tools that simplify and accelerate how we work with time
series data.

We can convert longitudinal data into a “**t**ime **s**eries tibble”, a
`tsibble`, which is built on top of the `tibble` package.

To convert longitudinal data to time series we need to consider:

  - What identifies the time component of the data? This is the
    **index**
  - What is the unique identifier of an individual/series? This is the
    **key**

Together, the **index** and **key** uniquely identify an observation.

What do we mean by this? Let’s look at the first section of the wages,
**wages** data analysed in Singer & Willett (2003):

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
slice(wages, 1:10)
#> # A tibble: 10 x 9
#>       id   lnw exper   ged postexp black hispanic   hgc uerate
#>    <int> <dbl> <dbl> <int>   <dbl> <int>    <int> <int>  <dbl>
#>  1    31  1.49 0.015     1   0.015     0        1     8   3.21
#>  2    31  1.43 0.715     1   0.715     0        1     8   3.21
#>  3    31  1.47 1.73      1   1.73      0        1     8   3.21
#>  4    31  1.75 2.77      1   2.77      0        1     8   3.3 
#>  5    31  1.93 3.93      1   3.93      0        1     8   2.89
#>  6    31  1.71 4.95      1   4.95      0        1     8   2.49
#>  7    31  2.09 5.96      1   5.96      0        1     8   2.6 
#>  8    31  2.13 6.98      1   6.98      0        1     8   4.8 
#>  9    36  1.98 0.315     1   0.315     0        0     9   4.89
#> 10    36  1.80 0.983     1   0.983     0        0     9   7.4
```

We have the `id` column, which identifies an individual.

We also have the `exper` column, which identifies the `exper`ience an
individual has.

So:

  - key: `id`
  - index: `exper`

We can specify these things using the `as_tsibble` function from
`tsibble`, also stating, `regular = FALSE`, since we have an `irregular`
time series.

``` r
library(tsibble)
#> 
#> Attaching package: 'tsibble'
#> The following object is masked from 'package:dplyr':
#> 
#>     id
wages_ts <- as_tsibble(x = wages,
                       key = id,
                       index = exper,
                       regular = FALSE)
```

This gives us:

``` r
wages_ts
#> # A tsibble: 6,402 x 9 [!]
#> # Key:       id [888]
#>       id   lnw exper   ged postexp black hispanic   hgc uerate
#>    <int> <dbl> <dbl> <int>   <dbl> <int>    <int> <int>  <dbl>
#>  1    31  1.49 0.015     1   0.015     0        1     8   3.21
#>  2    31  1.43 0.715     1   0.715     0        1     8   3.21
#>  3    31  1.47 1.73      1   1.73      0        1     8   3.21
#>  4    31  1.75 2.77      1   2.77      0        1     8   3.3 
#>  5    31  1.93 3.93      1   3.93      0        1     8   2.89
#>  6    31  1.71 4.95      1   4.95      0        1     8   2.49
#>  7    31  2.09 5.96      1   5.96      0        1     8   2.6 
#>  8    31  2.13 6.98      1   6.98      0        1     8   4.8 
#>  9    36  1.98 0.315     1   0.315     0        0     9   4.89
#> 10    36  1.80 0.983     1   0.983     0        0     9   7.4 
#> # … with 6,392 more rows
```

Note the following information printed at the top:

    # A tsibble: 6,402 x 9 [!]
    # Key:       id [888]
    ...

This says, we have 6402 rows, with 9 columns. The `!` means that there
is no regular spacing between series, and then our “key” is `id`, of
which there 888.

The `wages_ts` dataset is actually already made available inside the
`brolgar` package, so you won’t need to do this.

## Example usage

Let’s extract informative individual patterns by concentrating on
different statistics. A story can be woven that may be relevant rather
than speaking in generalities.

``` r
library(brolgar)
wages_ts
#> # A tsibble: 6,402 x 9 [!]
#> # Key:       id [888]
#>       id   lnw exper   ged postexp black hispanic   hgc uerate
#>    <int> <dbl> <dbl> <int>   <dbl> <int>    <int> <int>  <dbl>
#>  1    31  1.49 0.015     1   0.015     0        1     8   3.21
#>  2    31  1.43 0.715     1   0.715     0        1     8   3.21
#>  3    31  1.47 1.73      1   1.73      0        1     8   3.21
#>  4    31  1.75 2.77      1   2.77      0        1     8   3.3 
#>  5    31  1.93 3.93      1   3.93      0        1     8   2.89
#>  6    31  1.71 4.95      1   4.95      0        1     8   2.49
#>  7    31  2.09 5.96      1   5.96      0        1     8   2.6 
#>  8    31  2.13 6.98      1   6.98      0        1     8   4.8 
#>  9    36  1.98 0.315     1   0.315     0        0     9   4.89
#> 10    36  1.80 0.983     1   0.983     0        0     9   7.4 
#> # … with 6,392 more rows
```

### Calculating `features` of longitudinal data

Now that the data is converted to a `tsibble`, we can leverage the power
of the `features` family of functions from `feasts` and `fablelite`.

…

### Quick helper functions

  - `l_n_obs()` Number of observations
  - `l_slope()` Slope and intercept (given some linear model formula)

For example, we can calculate the number of observations with
`l_n_obs()`:

``` r
l_n_obs(wages_ts)
#> # A tibble: 888 x 2
#>       id n_obs
#>    <int> <int>
#>  1    31     8
#>  2    36    10
#>  3    53     8
#>  4   122    10
#>  5   134    12
#>  6   145     9
#>  7   155    11
#>  8   173     6
#>  9   206     3
#> 10   207    11
#> # … with 878 more rows
```

Which could be further summarised to get a sense of the range of the
data:

``` r
library(ggplot2)
l_n_obs(wages_ts) %>%
ggplot(aes(x = n_obs)) + 
  geom_bar()
```

<img src="man/figures/README-summarise-n-obs-1.png" width="100%" />

``` r

l_n_obs(wages_ts) %>% summary()
#>        id            n_obs       
#>  Min.   :   31   Min.   : 1.000  
#>  1st Qu.: 3332   1st Qu.: 5.000  
#>  Median : 6666   Median : 8.000  
#>  Mean   : 6343   Mean   : 7.209  
#>  3rd Qu.: 9194   3rd Qu.: 9.000  
#>  Max.   :12543   Max.   :13.000
```

## Identifying an individual of interest

We might be interested in showing the xp and ln\_wages, and so look at a
plot like the following:

``` r
data(wages_ts)
ggplot(wages_ts, 
       aes(x = xp, 
           y = ln_wages, 
           group = id)) + 
  geom_line()
```

<img src="man/figures/README-demo-brolgar-1.png" width="100%" />

This is a plate of spaghetti\! It is hard to understand\!

We can use `brolgar` to get the number of observations and slope
information for each individual to identify those that are decreasing
over time.

``` r
sl <- l_slope(wages_ts,ln_wages ~ xp)
ns <- l_n_obs(wages_ts)

sl
#> # A tibble: 888 x 3
#>       id l_intercept l_slope_xp
#>    <int>       <dbl>      <dbl>
#>  1    31        1.41     0.101 
#>  2    36        2.04     0.0588
#>  3    53        2.29    -0.358 
#>  4   122        1.93     0.0374
#>  5   134        2.03     0.0831
#>  6   145        1.59     0.0469
#>  7   155        1.66     0.0867
#>  8   173        1.61     0.100 
#>  9   206        1.73     0.180 
#> 10   207        1.62     0.0884
#> # … with 878 more rows
ns
#> # A tibble: 888 x 2
#>       id n_obs
#>    <int> <int>
#>  1    31     8
#>  2    36    10
#>  3    53     8
#>  4   122    10
#>  5   134    12
#>  6   145     9
#>  7   155    11
#>  8   173     6
#>  9   206     3
#> 10   207    11
#> # … with 878 more rows
```

We can then join these summaries back to the data:

``` r
wages_lg <- wages_ts %>%
  left_join(sl, by = "id") %>%
  left_join(ns, by = "id")

wages_lg
#> # A tsibble: 6,402 x 12 [!]
#> # Key:       id [888]
#>       id ln_wages    xp   ged postexp black hispanic high_grade
#>    <int>    <dbl> <dbl> <int>   <dbl> <int>    <int>      <int>
#>  1    31     1.49 0.015     1   0.015     0        1          8
#>  2    31     1.43 0.715     1   0.715     0        1          8
#>  3    31     1.47 1.73      1   1.73      0        1          8
#>  4    31     1.75 2.77      1   2.77      0        1          8
#>  5    31     1.93 3.93      1   3.93      0        1          8
#>  6    31     1.71 4.95      1   4.95      0        1          8
#>  7    31     2.09 5.96      1   5.96      0        1          8
#>  8    31     2.13 6.98      1   6.98      0        1          8
#>  9    36     1.98 0.315     1   0.315     0        0          9
#> 10    36     1.80 0.983     1   0.983     0        0          9
#> # … with 6,392 more rows, and 4 more variables: unemploy_rate <dbl>,
#> #   l_intercept <dbl>, l_slope_xp <dbl>, n_obs <int>
```

We can then highlight those individuals with more than 5 observations,
and highlight those with a negative slope using `gghighlight`:

``` r
library(gghighlight)

wages_lg %>% 
  filter(n_obs > 5) %>%
  ggplot(aes(x = xp, 
             y = ln_wages, 
             group = id)) + 
  geom_line() +
  gghighlight(l_slope_xp < (-0.5),
              use_direct_label = FALSE)
#> Warning: Unspecified temporal ordering may yield unexpected results.
#> Suggest to sort by `id`, `xp` first.

#> Warning: Unspecified temporal ordering may yield unexpected results.
#> Suggest to sort by `id`, `xp` first.
```

<img src="man/figures/README-use-gg-highlight-1.png" width="100%" />

## Filtering by the number of observations

You can filter by the number of observations using `filter_n_obs()`

``` r

wages_ts %>% filter_n_obs(n_obs > 3)
#> # A tsibble: 6,145 x 10 [!]
#> # Key:       id [764]
#>       id ln_wages    xp   ged postexp black hispanic high_grade
#>    <int>    <dbl> <dbl> <int>   <dbl> <int>    <int>      <int>
#>  1    31     1.49 0.015     1   0.015     0        1          8
#>  2    31     1.43 0.715     1   0.715     0        1          8
#>  3    31     1.47 1.73      1   1.73      0        1          8
#>  4    31     1.75 2.77      1   2.77      0        1          8
#>  5    31     1.93 3.93      1   3.93      0        1          8
#>  6    31     1.71 4.95      1   4.95      0        1          8
#>  7    31     2.09 5.96      1   5.96      0        1          8
#>  8    31     2.13 6.98      1   6.98      0        1          8
#>  9    36     1.98 0.315     1   0.315     0        0          9
#> 10    36     1.80 0.983     1   0.983     0        0          9
#> # … with 6,135 more rows, and 2 more variables: unemploy_rate <dbl>,
#> #   n_obs <int>

wages_ts %>% filter_n_obs(n_obs == 1)
#> # A tsibble: 38 x 10 [!]
#> # Key:       id [38]
#>       id ln_wages    xp   ged postexp black hispanic high_grade
#>    <int>    <dbl> <dbl> <int>   <dbl> <int>    <int>      <int>
#>  1   266     1.81 0.322     1   0.182     0        0          9
#>  2   304     1.84 0.580     0   0         0        1          8
#>  3   911     2.51 1.67      1   1.67      1        0         11
#>  4  1032     1.65 0.808     0   0         1        0          8
#>  5  1219     1.57 1.5       0   0         1        0          9
#>  6  1282     2.22 0.292     1   0.292     0        0         11
#>  7  1542     1.81 0.173     0   0         0        0         10
#>  8  1679     1.94 0.365     1   0         0        0         10
#>  9  2065     2.60 1.5       0   0         0        0         11
#> 10  2261     2.25 0.005     0   0         0        0          6
#> # … with 28 more rows, and 2 more variables: unemploy_rate <dbl>,
#> #   n_obs <int>
```

## Calculating all features

You can calculate all longnostics passing getting all features from
brolgar using `feat_brolgar`

``` r
library(fablelite)

wages_ts %>%
  features(xp, feat_brolgar)
#> # A tibble: 888 x 14
#>       id b_min b_max b_median b_mean b_q25 b_q75 b_range1 b_range2
#>    <int> <dbl> <dbl>    <dbl>  <dbl> <dbl> <dbl>    <dbl>    <dbl>
#>  1    31 0.015  6.98     3.35   3.38 1.14   5.54    0.015     6.98
#>  2    36 0.315  9.60     4.77   4.90 1.95   7.98    0.315     9.60
#>  3    53 0.781  1.78     1.05   1.11 0.949  1.15    0.781     1.78
#>  4   122 2.04  11.1      6.27   6.42 3.57   9.20    2.04     11.1 
#>  5   134 0.192 10.8      5.14   5.43 2.36   8.70    0.192    10.8 
#>  6   145 0.235  7.1      3.70   3.70 1.49   5.99    0.235     7.1 
#>  7   155 0.985 10.4      5.72   5.84 3.11   8.78    0.985    10.4 
#>  8   173 0.188  6.40     3.32   3.23 0.749  5.46    0.188     6.40
#>  9   206 1.87   4.31     2.81   3.00 2.03   4.06    1.87      4.31
#> 10   207 0.525 10.3      5.46   5.55 2.82   8.46    0.525    10.3 
#> # … with 878 more rows, and 5 more variables: b_range_diff <dbl>,
#> #   b_sd <dbl>, b_var <dbl>, b_mad <dbl>, b_iqr <dbl>
```

# A Note on the API

This version of brolgar was been forked from
[tprvan/brolgar](https://github.com/tprvan/brolgar), and has undergone
breaking changes to the API.

# Further functions in brolgar

There are various summary statistics in `brolgar`, which all start with
`b_`.

  - `b_min()` Minimum
  - `b_max()` Maximum
  - `b_mean()` Mean
  - `b_diff()` Lagged difference (by default, the first order
    difference)
  - `b_q25()` 25th quartile
  - `b_median()` Median value
  - `b_q75()` 75th quartile
  - `b_sd()` Standard deviation
