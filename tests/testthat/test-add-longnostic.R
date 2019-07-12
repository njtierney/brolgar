context("test-add-longnostic")

df_add_l_diff_1 <- features(wages_ts, ln_wages, diff) %>% left_join(wages_ts, by = "id")
df_add_n_key_obs <- add_n_key_obs(wages_ts)
df_add_key_slope <- add_key_slope(wages_ts, ln_wages ~ xp)
df_add_key_slope_multi <- add_key_slope(wages_ts, ln_wages ~ xp + ged)

updated_dim <- c(nrow(wages), ncol(wages) + 1)

test_that("longnostics returns the right dimensions", {
  expect_equal(dim(df_add_l_diff_1), updated_dim)
  expect_equal(dim(df_add_n_key_obs), updated_dim)
  expect_equal(dim(df_add_key_slope), c(nrow(wages), ncol(wages) + 2))
  expect_equal(dim(df_add_key_slope_multi), c(nrow(wages), ncol(wages) + 3))
})

add_new_names <- function(data, x){
  c(names(data)[1], 
    x,
    names(data)[2:ncol(data)])
}

test_that("longnostic returns the right names", {
  expect_equal(names(df_add_l_diff_1), add_new_names(wages_ts,
                                                     "V1"))
  expect_equal(names(df_add_n_key_obs), c(names(wages_ts), "n_obs"))
  expect_equal(names(df_add_key_slope), 
               add_new_names(wages_ts,
                                  c(".intercept",
                                    ".slope_xp")))
  expect_equal(names(df_add_key_slope_multi), 
               add_new_names(wages_ts,
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
