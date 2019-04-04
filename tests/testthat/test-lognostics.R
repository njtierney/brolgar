context("test-longostic")

df_l_diff_1 <- l_diff(wages, id, lnw, lag = 1)
df_l_diff_2 <- l_diff(wages, id, lnw, lag = 2)
df_l_n_obs <- l_n_obs(wages, id, lnw)
df_l_max <- l_max(wages, id, lnw)
df_l_mean <- l_mean(wages, id, lnw)
df_l_median <- l_median(wages, id, lnw)
df_l_min <- l_min(wages, id, lnw)
df_l_q1 <- l_q1(wages, id, lnw)
df_l_q3 <- l_q3(wages, id, lnw)
df_l_sd <- l_sd(wages, id, lnw)
df_l_slope <- l_slope(wages, id, lnw~exper)

test_that("longnostics returns the right dimensions", {
  expect_equal(dim(df_l_diff_1), c(888, 2))
  expect_equal(dim(df_l_diff_2), c(888, 2))
  expect_equal(dim(df_l_n_obs), c(888, 2))
  expect_equal(dim(df_l_max), c(888, 2))
  expect_equal(dim(df_l_mean), c(888, 2))
  expect_equal(dim(df_l_median), c(888, 2))
  expect_equal(dim(df_l_min), c(888, 2))
  expect_equal(dim(df_l_q1), c(888, 2))
  expect_equal(dim(df_l_q3), c(888, 2))
  expect_equal(dim(df_l_sd), c(888, 2))
  expect_equal(dim(df_l_slope), c(888, 3))
})

test_that("longnostic returns the right names", {
  expect_equal(names(df_l_diff_1), c("id", "l_diff_1"))
  expect_equal(names(df_l_diff_2), c("id", "l_diff_2"))
  expect_equal(names(df_l_n_obs), c("id", "l_n_obs"))
  expect_equal(names(df_l_max), c("id", "l_max"))
  expect_equal(names(df_l_mean), c("id", "l_mean"))
  expect_equal(names(df_l_median), c("id", "l_median"))
  expect_equal(names(df_l_min), c("id", "l_min"))
  expect_equal(names(df_l_q1), c("id", "l_q1"))
  expect_equal(names(df_l_q3), c("id", "l_q3"))
  expect_equal(names(df_l_sd), c("id", "l_sd"))
  expect_equal(names(df_l_slope), c("id", "l_intercept", "l_slope"))
})

test_that("longnostic returns a tbl_df", {
  expect_is(df_l_diff_1, class = c("tbl"))
  expect_is(df_l_diff_2, class = c("tbl"))
  expect_is(df_l_n_obs, class = c("tbl"))
  expect_is(df_l_max, class = c("tbl"))
  expect_is(df_l_mean, class = c("tbl"))
  expect_is(df_l_median, class = c("tbl"))
  expect_is(df_l_min, class = c("tbl"))
  expect_is(df_l_q1, class = c("tbl"))
  expect_is(df_l_q3, class = c("tbl"))
  expect_is(df_l_sd, class = c("tbl"))
  expect_is(df_l_slope, class = c("tbl"))
})

test_that("longnostic returns correct classes", {
  expect_equal(purrr::map_chr(df_l_diff_1, class), 
               c(id = "integer", l_diff_1 = "numeric"))
  expect_equal(purrr::map_chr(df_l_diff_2, class),
               c(id = "integer", l_diff_2 = "numeric"))
  expect_equal(purrr::map_chr(df_l_n_obs, class),
               c(id = "integer", l_n_obs = "integer"))
  expect_equal(purrr::map_chr(df_l_max, class),
               c(id = "integer", l_max = "numeric"))
  expect_equal(purrr::map_chr(df_l_mean, class),
               c(id = "integer", l_mean = "numeric"))
  expect_equal(purrr::map_chr(df_l_median, class),
               c(id = "integer", l_median = "numeric"))
  expect_equal(purrr::map_chr(df_l_min, class),
               c(id = "integer", l_min = "numeric"))
  expect_equal(purrr::map_chr(df_l_q1, class),
               c(id = "integer", l_q1 = "numeric"))
  expect_equal(purrr::map_chr(df_l_q3, class),
               c(id = "integer", l_q3 = "numeric"))
  expect_equal(purrr::map_chr(df_l_sd, class),
               c(id = "integer", l_sd = "numeric"))
  expect_equal(purrr::map_chr(df_l_slope, class),
               c(id = "integer", l_intercept = "numeric", l_slope = "numeric"))
})
