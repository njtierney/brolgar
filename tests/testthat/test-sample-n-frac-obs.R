context("test-sample-n-frac-obs")

l_sample_n_obs <- sample_n_obs(data = wages,
                               id = id,
                               size = 10)

l_sample_frac_obs <- sample_frac_obs(data = wages,
                                     id = id,
                                     size = 0.11)

test_that("correct number of columns returned",{
  expect_equal(ncol(l_sample_n_obs), ncol(wages))
  expect_equal(ncol(l_sample_frac_obs), ncol(wages))
})

test_that("correct number of ids returned",{
  expect_equal(dplyr::n_distinct(l_sample_n_obs$id), 10)
  expect_equal(dplyr::n_distinct(l_sample_frac_obs$id), 98)
})

test_that("correct names returned", {
  expect_equal(names(l_sample_n_obs), names(wages))
  expect_equal(names(l_sample_frac_obs), names(wages))
})

test_that("Returns a tibble", {
  expect_is(l_sample_n_obs, "tbl")
  expect_is(l_sample_frac_obs, "tbl")
})

classes <- function(x) purrr::map_chr(x, class)

test_that("Returns correct classes", {
  expect_equal(classes(l_sample_n_obs), classes(wages))
  expect_equal(classes(l_sample_frac_obs), classes(wages))
})