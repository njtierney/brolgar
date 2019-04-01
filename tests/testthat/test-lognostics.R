context("test-lognostics")

df_l_d1 <- l_d1(wages, "id", "lnw")
df_l_length <- l_length(wages, "id", "lnw")
df_l_max <- l_max(wages, "id", "lnw")
df_l_mean <- l_mean(wages, "id", "lnw")
df_l_median <- l_median(wages, "id", "lnw")
df_l_min <- l_min(wages, "id", "lnw")
df_l_q1 <- l_q1(wages, "id", "lnw")
df_l_q3 <- l_q3(wages, "id", "lnw")
df_l_sd <- l_sd(wages, "id", "lnw")
df_l_slope <- l_slope(wages, "id", "lnw~exper")

test_that("lognostics returns the right dimensions", {
  expect_equal(dim(df_l_d1), c(888, 2))
  expect_equal(dim(df_l_length), c(888, 2))
  expect_equal(dim(df_l_max), c(888, 2))
  expect_equal(dim(df_l_mean), c(888, 2))
  expect_equal(dim(df_l_median), c(888, 2))
  expect_equal(dim(df_l_min), c(888, 2))
  expect_equal(dim(df_l_q1), c(888, 2))
  expect_equal(dim(df_l_q3), c(888, 2))
  expect_equal(dim(df_l_sd), c(888, 2))
  expect_equal(dim(df_l_slope), c(888, 3))
})

test_that("l_mean returns the right names", {
  expect_equal(names(df_l_d1), c("id", "m"))
  expect_equal(names(df_l_length), c("id", "n"))
  expect_equal(names(df_l_max), c("id", "m"))
  expect_equal(names(df_l_mean), c("id", "m"))
  expect_equal(names(df_l_median), c("id", "m"))
  expect_equal(names(df_l_min), c("id", "m"))
  expect_equal(names(df_l_q1), c("id", "m"))
  expect_equal(names(df_l_q3), c("id", "m"))
  expect_equal(names(df_l_sd), c("id", "m"))
  expect_equal(names(df_l_slope), c("id", "intercept", "slope"))
})

test_that("l_mean returns a tbl_df", {
  expect_is(df_l_d1, class = c("tbl"))
  expect_is(df_l_d1, class = c("tbl"))
  expect_is(df_l_length, class = c("tbl"))
  expect_is(df_l_max, class = c("tbl"))
  expect_is(df_l_mean, class = c("tbl"))
  expect_is(df_l_median, class = c("tbl"))
  expect_is(df_l_min, class = c("tbl"))
  expect_is(df_l_q1, class = c("tbl"))
  expect_is(df_l_q3, class = c("tbl"))
  expect_is(df_l_sd, class = c("tbl"))
  expect_is(df_l_slope, class = c("tbl"))
})

test_that("l_mean returns correct classes", {
  expect_equal(purrr::map_chr(df_l_d1, class), 
               c(id = "integer", m = "numeric"))
  expect_equal(purrr::map_chr(df_l_d1, class),
               c(id = "integer", m = "numeric"))
  expect_equal(purrr::map_chr(df_l_length, class),
               c(id = "integer", n = "numeric"))
  expect_equal(purrr::map_chr(df_l_max, class),
               c(id = "integer", m = "numeric"))
  expect_equal(purrr::map_chr(df_l_mean, class),
               c(id = "integer", m = "numeric"))
  expect_equal(purrr::map_chr(df_l_median, class),
               c(id = "integer", m = "numeric"))
  expect_equal(purrr::map_chr(df_l_min, class),
               c(id = "integer", m = "numeric"))
  expect_equal(purrr::map_chr(df_l_q1, class),
               c(id = "integer", m = "numeric"))
  expect_equal(purrr::map_chr(df_l_q3, class),
               c(id = "integer", m = "numeric"))
  expect_equal(purrr::map_chr(df_l_sd, class),
               c(id = "integer", m = "numeric"))
  expect_equal(purrr::map_chr(df_l_slope, class),
               c(id = "integer", intercept = "numeric", slope = "numeric"))
})
