context("test-longnostic")
wages_test <- sample_frac_keys(wages, 0.05)

df_l_range_1 <- features(wages_test, ln_wages, 
                         list(range = ~ setNames(b_range(.), c("min", "max"))))
df_l_max <- features(wages_test, ln_wages, c(max = b_max))
df_l_mean <- features(wages_test, ln_wages, c(mean = b_mean))
df_l_median <- features(wages_test, ln_wages, c(median = b_median))
df_l_min <- features(wages_test, ln_wages, c(min = b_min))
df_l_q1 <- features(wages_test, ln_wages, c(q25 = b_q25))
df_l_q3 <- features(wages_test, ln_wages, c(q75 = b_q75))
df_l_sd <- features(wages_test, ln_wages, c(sd = b_sd))
df_l_slope <- key_slope(wages_test, ln_wages ~ xp)
df_l_slope_multi <- key_slope(wages_test, ln_wages ~ xp + ged)

new_dims <- c(n_keys(wages_test), 2)

test_that("longnostics returns the right dimensions", {
  expect_equal(dim(df_l_range_1), c(new_dims[1], new_dims[2] + 1))
  expect_equal(dim(df_l_max), new_dims)
  expect_equal(dim(df_l_mean), new_dims)
  expect_equal(dim(df_l_median), new_dims)
  expect_equal(dim(df_l_min), new_dims)
  expect_equal(dim(df_l_q1), new_dims)
  expect_equal(dim(df_l_q3), new_dims)
  expect_equal(dim(df_l_sd), new_dims)
  expect_equal(dim(df_l_slope), c(n_keys(wages_test), 3))
  expect_equal(dim(df_l_slope_multi), c(n_keys(wages_test), 4))
})

test_that("longnostic returns the right names", {
  expect_equal(names(df_l_range_1), c("id", "range_min", "range_max"))
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
  expect_is(df_l_range_1, class = c("tbl"))
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
  expect_equal(classes(df_l_range_1), 
               c(id = "integer", 
                 range_min = "numeric",
                 range_max = "numeric"))
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

test_that("add-key-slope returns different slopes and intercepts",{
  expect_gte(n_distinct(df_l_slope$.intercept), 2)
  expect_gte(n_distinct(df_l_slope$.slope_xp), 2)
})
