context("test-add-longostic")

df_add_l_diff_1 <- add_l_diff(wages, id, lnw, lag = 1)
df_add_l_diff_2 <- add_l_diff(wages, id, lnw, lag = 2)
df_add_l_n_obs <- add_l_n_obs(wages, id)
df_add_l_max <- add_l_max(wages, id, lnw)
df_add_l_mean <- add_l_mean(wages, id, lnw)
df_add_l_median <- add_l_median(wages, id, lnw)
df_add_l_min <- add_l_min(wages, id, lnw)
df_add_l_q1 <- add_l_q1(wages, id, lnw)
df_add_l_q3 <- add_l_q3(wages, id, lnw)
df_add_l_sd <- add_l_sd(wages, id, lnw)
df_add_l_slope <- add_l_slope(wages, id, lnw~exper)

updated_dim <- c(nrow(wages), ncol(wages) + 1)

test_that("longnostics returns the right dimensions", {
  expect_equal(dim(df_add_l_diff_1), updated_dim)
  expect_equal(dim(df_add_l_diff_2), updated_dim)
  expect_equal(dim(df_add_l_n_obs), updated_dim)
  expect_equal(dim(df_add_l_max), updated_dim)
  expect_equal(dim(df_add_l_mean), updated_dim)
  expect_equal(dim(df_add_l_median), updated_dim)
  expect_equal(dim(df_add_l_min), updated_dim)
  expect_equal(dim(df_add_l_q1), updated_dim)
  expect_equal(dim(df_add_l_q3), updated_dim)
  expect_equal(dim(df_add_l_sd), updated_dim)
  expect_equal(dim(df_add_l_slope), c(nrow(wages), ncol(wages) + 2))
})

add_new_wage_names <- function(x){
  c(names(wages)[1], 
    x,
    names(wages)[2:ncol(wages)])
}

test_that("longnostic returns the right names", {
  expect_equal(names(df_add_l_diff_1), add_new_wage_names("l_diff_1"))
  expect_equal(names(df_add_l_diff_2), add_new_wage_names("l_diff_2"))
  expect_equal(names(df_add_l_n_obs), add_new_wage_names("l_n_obs"))
  expect_equal(names(df_add_l_max), add_new_wage_names("l_max"))
  expect_equal(names(df_add_l_mean), add_new_wage_names("l_mean"))
  expect_equal(names(df_add_l_median), add_new_wage_names("l_median"))
  expect_equal(names(df_add_l_min), add_new_wage_names("l_min"))
  expect_equal(names(df_add_l_q1), add_new_wage_names("l_q1"))
  expect_equal(names(df_add_l_q3), add_new_wage_names("l_q3"))
  expect_equal(names(df_add_l_sd), add_new_wage_names("l_sd"))
  expect_equal(names(df_add_l_slope), add_new_wage_names(c("l_intercept", "l_slope")))
})

test_that("longnostic returns a tbl_df", {
  expect_is(df_add_l_diff_1, class = c("tbl"))
  expect_is(df_add_l_diff_2, class = c("tbl"))
  expect_is(df_add_l_n_obs, class = c("tbl"))
  expect_is(df_add_l_max, class = c("tbl"))
  expect_is(df_add_l_mean, class = c("tbl"))
  expect_is(df_add_l_median, class = c("tbl"))
  expect_is(df_add_l_min, class = c("tbl"))
  expect_is(df_add_l_q1, class = c("tbl"))
  expect_is(df_add_l_q3, class = c("tbl"))
  expect_is(df_add_l_sd, class = c("tbl"))
  expect_is(df_add_l_slope, class = c("tbl"))
})

classes <- function(x) purrr::map_chr(x, class)

test_that("longnostic returns correct classes", {
  expect_equal(classes(df_add_l_diff_1)[["l_diff_1"]], "numeric")
  expect_equal(classes(df_add_l_diff_2)[["l_diff_2"]], "numeric")
  expect_equal(classes(df_add_l_n_obs)[["l_n_obs"]], "integer")
  expect_equal(classes(df_add_l_max)[["l_max"]], "numeric")
  expect_equal(classes(df_add_l_mean)[["l_mean"]], "numeric")
  expect_equal(classes(df_add_l_median)[["l_median"]], "numeric")
  expect_equal(classes(df_add_l_min)[["l_min"]], "numeric")
  expect_equal(classes(df_add_l_q1)[["l_q1"]], "numeric")
  expect_equal(classes(df_add_l_q3)[["l_q3"]], "numeric")
  expect_equal(classes(df_add_l_sd)[["l_sd"]], "numeric")
  expect_equal(classes(df_add_l_slope)[["l_intercept"]], "numeric")
  expect_equal(classes(df_add_l_slope)[["l_slope"]], "numeric")
})
