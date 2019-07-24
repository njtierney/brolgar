context("test-add-longnostic")
library(dplyr)

wages_test <- sample_frac_keys(wages_ts, 0.05)

df_add_l_diff_1 <- wages_test %>%
                    features(ln_wages, 
                             diff) %>% 
                     left_join(wages_test, by = "id")
df_add_n_key_obs <- add_n_key_obs(wages_test)
df_add_key_slope <- add_key_slope(wages_test, ln_wages ~ xp)
df_add_key_slope_multi <- add_key_slope(wages_test, ln_wages ~ xp + ged)

updated_dim <- c(nrow(wages_test), ncol(wages_test) + 1)

test_that("add_* funs return a tsibble", {
  expect_is(df_add_n_key_obs, class = c("tbl_ts"))
  expect_is(df_add_key_slope, class = c("tbl_ts"))
  expect_is(df_add_key_slope_multi, class = c("tbl_ts"))
})


test_that("longnostics returns the right dimensions", {
  expect_equal(dim(df_add_l_diff_1), updated_dim)
  expect_equal(dim(df_add_n_key_obs), updated_dim)
  expect_equal(dim(df_add_key_slope), c(nrow(wages_test), 
                                        ncol(wages_test) + 2))
  expect_equal(dim(df_add_key_slope_multi), c(nrow(wages_test), 
                                              ncol(wages_test) + 3))
})

test_that("longnostic returns the right names", {
  expect_equal(names(df_add_l_diff_1), 
               c(names(wages_test)[1],
                 "V1",
                 names(wages_test)[2:length(names(wages_test))])
  )
  expect_equal(names(df_add_n_key_obs), 
               add_new_names(wages_test, "n_obs"))
  expect_equal(names(df_add_key_slope), 
               add_new_names(wages_test,
                                  c(".intercept",
                                    ".slope_xp")))
  expect_equal(names(df_add_key_slope_multi), 
               add_new_names(wages_test,
                             c(".intercept", 
                               ".slope_xp", 
                               ".slope_ged")))
})

test_that("longnostic returns a tbl_df", {
  expect_is(df_add_l_diff_1, class = c("tbl"))
  expect_is(df_add_n_key_obs, class = c("tbl"))
  expect_is(df_add_key_slope, class = c("tbl"))
  expect_is(df_add_key_slope_multi, class = c("tbl"))
})

classes <- function(x) purrr::map_chr(x, class)

test_that("longnostic returns correct classes", {
  expect_equal(classes(df_add_l_diff_1)[["V1"]], "numeric")
  expect_equal(classes(df_add_n_key_obs)[["n_obs"]], "integer")
  expect_equal(classes(df_add_key_slope)[[".intercept"]], "numeric")
  expect_equal(classes(df_add_key_slope)[[".slope_xp"]], "numeric")
  expect_equal(classes(df_add_key_slope_multi)[[".intercept"]], "numeric")
  expect_equal(classes(df_add_key_slope_multi)[[".slope_xp"]], 
               "numeric")
  expect_equal(classes(df_add_key_slope_multi)[[".slope_ged"]], "numeric")
})

library(dplyr)
test_that("add-key-slope returns different slopes and intercepts",{
  expect_gte(n_distinct(df_add_key_slope$.intercept), 2)
  expect_gte(n_distinct(df_add_key_slope$.slope_xp), 2)
          })
