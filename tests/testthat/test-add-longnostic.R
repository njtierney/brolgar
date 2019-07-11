context("test-add-longnostic")

df_add_l_diff_1 <- add_l_diff(wages, id, lnw, lag = 1)
df_add_l_diff_2 <- add_l_diff(wages, id, lnw, lag = 2)
df_add_l_n_obs <- add_l_n_obs(wages_ts)
df_add_l_slope <- add_l_slope(wages_ts, id, ln_wages ~ experience)
df_add_l_slope_multi <- add_l_slope(wages_ts, id, ln_wages ~ experience + ged)

updated_dim <- c(nrow(wages), ncol(wages) + 1)

test_that("longnostics returns the right dimensions", {
  expect_equal(dim(df_add_l_diff_1), updated_dim)
  expect_equal(dim(df_add_l_diff_2), updated_dim)
  expect_equal(dim(df_add_l_n_obs), updated_dim)
  expect_equal(dim(df_add_l_slope), c(nrow(wages), ncol(wages) + 2))
  expect_equal(dim(df_add_l_slope_multi), c(nrow(wages), ncol(wages) + 3))
})

add_new_names <- function(data, x){
  c(names(data)[1], 
    x,
    names(data)[2:ncol(data)])
}

test_that("longnostic returns the right names", {
  expect_equal(names(df_add_l_diff_1), add_new_names(wages,
                                                     "l_diff_1"))
  expect_equal(names(df_add_l_diff_2), add_new_names(wages,
                                                     "l_diff_2"))
  expect_equal(names(df_add_l_n_obs), c(names(wages_ts), "n_obs"))
  expect_equal(names(df_add_l_slope), 
               add_new_wage_names(wages_ts,
                                  c("l_intercept",
                                    "l_slope_experience")))
  expect_equal(names(df_add_l_slope_multi), 
               add_new_names(wages_ts,
                             c("l_intercept", 
                               "l_slope_experience", 
                               "l_slope_ged")))
})

test_that("longnostic returns a tbl_df", {
  expect_is(df_add_l_diff_1, class = c("tbl"))
  expect_is(df_add_l_diff_2, class = c("tbl"))
  expect_is(df_add_l_n_obs, class = c("tbl"))
  expect_is(df_add_l_slope, class = c("tbl"))
  expect_is(df_add_l_slope_multi, class = c("tbl"))
})

classes <- function(x) purrr::map_chr(x, class)

test_that("longnostic returns correct classes", {
  expect_equal(classes(df_add_l_diff_1)[["l_diff_1"]], "numeric")
  expect_equal(classes(df_add_l_diff_2)[["l_diff_2"]], "numeric")
  expect_equal(classes(df_add_l_n_obs)[["n_obs"]], "integer")
  expect_equal(classes(df_add_l_slope)[["l_intercept"]], "numeric")
  expect_equal(classes(df_add_l_slope)[["l_slope_experience"]], "numeric")
  expect_equal(classes(df_add_l_slope_multi)[["l_intercept"]], "numeric")
  expect_equal(classes(df_add_l_slope_multi)[["l_slope_experience"]], 
               "numeric")
  expect_equal(classes(df_add_l_slope_multi)[["l_slope_ged"]], "numeric")
})
