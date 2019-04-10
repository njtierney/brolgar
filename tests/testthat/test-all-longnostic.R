context("test-all-longnostic")

all_l <- longnostic_all(data = wages, 
                        id = id,
                        var = lnw,
                        formula = lnw~exper)

test_that("correct number of columns for all longnostics",{
          expect_equal(ncol(all_l), 12)
})

test_that("correct number of rows for all longnostics",{
          expect_equal(nrow(all_l), 888)
})

test_that("correct names for all longnostics", {
  expect_equal(names(all_l),
               c("id",
                 "l_diff_1",
                 "l_max",
                 "l_mean",
                 "l_median",
                 "l_min",
                 "l_n_obs",
                 "l_q1",
                 "l_q3",
                 "l_sd",
                 "l_intercept",
                 "l_slope_exper"))
})

test_that("longnostic_all returns a tibble", {
  expect_is(all_l, "tbl")
})

classes <- function(x) purrr::map_chr(x, class)

test_that("longnostic_all returns correct classes", {
  expect_equal(classes(all_l),
               c(id = "integer",
                 l_diff_1 = "numeric",
                 l_max = "numeric",
                 l_mean = "numeric",
                 l_median = "numeric",
                 l_min = "numeric",
                 l_n_obs = "integer",
                 l_q1 = "numeric",
                 l_q3 = "numeric",
                 l_sd = "numeric",
                 l_intercept = "numeric",
                 l_slope_exper = "numeric"))
})