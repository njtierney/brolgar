context("test-longnostic")

df_l_diff_1 <- features(wages_ts, ln_wages, diff)
df_n_key_obs <- n_key_obs(wages_ts)
df_l_max <- features(wages_ts, ln_wages, c(max = b_max))
df_l_mean <- features(wages_ts, ln_wages, c(mean = b_mean))
df_l_median <- features(wages_ts, ln_wages, c(median = b_median))
df_l_min <- features(wages_ts, ln_wages, c(min = b_min))
df_l_q1 <- features(wages_ts, ln_wages, c(q25 = b_q25))
df_l_q3 <- features(wages_ts, ln_wages, c(q75 = b_q75))
df_l_sd <- features(wages_ts, ln_wages, c(sd = b_sd))
df_l_slope <- key_slope(wages_ts, ln_wages ~ xp)
df_l_slope_multi <- key_slope(wages_ts, ln_wages ~ xp + ged)

test_that("longnostics returns the right dimensions", {
  expect_equal(dim(df_l_diff_1), c(888, 2))
  expect_equal(dim(df_n_key_obs), c(888, 2))
  expect_equal(dim(df_l_max), c(888, 2))
  expect_equal(dim(df_l_mean), c(888, 2))
  expect_equal(dim(df_l_median), c(888, 2))
  expect_equal(dim(df_l_min), c(888, 2))
  expect_equal(dim(df_l_q1), c(888, 2))
  expect_equal(dim(df_l_q3), c(888, 2))
  expect_equal(dim(df_l_sd), c(888, 2))
  expect_equal(dim(df_l_slope), c(888, 3))
  expect_equal(dim(df_l_slope_multi), c(888, 4))
})

test_that("longnostic returns the right names", {
  expect_equal(names(df_l_diff_1), c("id", "V1"))
  expect_equal(names(df_n_key_obs), c("id", "n_obs"))
  expect_equal(names(df_l_max), c("id", "max"))
  expect_equal(names(df_l_mean), c("id", "mean"))
  expect_equal(names(df_l_median), c("id", "median"))
  expect_equal(names(df_l_min), c("id", "min"))
  expect_equal(names(df_l_q1), c("id", "q25"))
  expect_equal(names(df_l_q3), c("id", "q75"))
  expect_equal(names(df_l_sd), c("id", "sd"))
  expect_equal(names(df_l_slope), c("id", 
                                    ".intercept", 
                                    ".slope_xp"))
  expect_equal(names(df_l_slope_multi), c("id", 
                                          ".intercept", 
                                          ".slope_xp", 
                                          ".slope_ged"))
})

test_that("longnostic returns a tbl_df", {
  expect_is(df_l_diff_1, class = c("tbl"))
  expect_is(df_n_key_obs, class = c("tbl"))
  expect_is(df_l_max, class = c("tbl"))
  expect_is(df_l_mean, class = c("tbl"))
  expect_is(df_l_median, class = c("tbl"))
  expect_is(df_l_min, class = c("tbl"))
  expect_is(df_l_q1, class = c("tbl"))
  expect_is(df_l_q3, class = c("tbl"))
  expect_is(df_l_sd, class = c("tbl"))
  expect_is(df_l_slope, class = c("tbl"))
  expect_is(df_l_slope_multi, class = c("tbl"))
})

classes <- function(x) purrr::map_chr(x, class)

test_that("longnostic returns correct classes", {
  expect_equal(classes(df_l_diff_1), 
               c(id = "integer", V1 = "numeric"))
  expect_equal(classes(df_n_key_obs),
               c(id = "integer", n_obs = "integer"))
  expect_equal(classes(df_l_max),
               c(id = "integer", max = "numeric"))
  expect_equal(classes(df_l_mean),
               c(id = "integer", mean = "numeric"))
  expect_equal(classes(df_l_median),
               c(id = "integer", median = "numeric"))
  expect_equal(classes(df_l_min),
               c(id = "integer", min = "numeric"))
  expect_equal(classes(df_l_q1),
               c(id = "integer", q25 = "numeric"))
  expect_equal(classes(df_l_q3),
               c(id = "integer", q75 = "numeric"))
  expect_equal(classes(df_l_sd),
               c(id = "integer", sd = "numeric"))
  expect_equal(classes(df_l_slope),
               c(id = "integer", 
                 .intercept = "numeric", 
                 .slope_xp = "numeric"))
  expect_equal(classes(df_l_slope_multi),
               c(id = "integer", .intercept = "numeric", 
                 .slope_xp = "numeric", .slope_ged = "numeric"))
})


library(dplyr)
test_that("add-key-slope returns different slopes and intercepts",{
  expect_equal(n_distinct(df_l_slope$.intercept), 887)
  expect_equal(n_distinct(df_l_slope$.slope_xp), 851)
})