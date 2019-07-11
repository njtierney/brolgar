context("test-sample-n-frac-obs")

l_sample_n_key <- sample_n_key(.data = wages, 
                               key = id,
                               size = 10)

l_sample_frac_key <- sample_frac_key(.data = wages,
                                     key = id,
                                     size = 0.11)

test_that("correct number of columns returned",{
  expect_equal(ncol(l_sample_n_key), ncol(wages))
  expect_equal(ncol(l_sample_frac_key), ncol(wages))
})

test_that("correct number of ids returned",{
  expect_equal(dplyr::n_distinct(l_sample_n_key$id), 10)
  expect_equal(dplyr::n_distinct(l_sample_frac_key$id), 98)
})

test_that("correct names returned", {
  expect_equal(names(l_sample_n_key), names(wages))
  expect_equal(names(l_sample_frac_key), names(wages))
})

test_that("Returns a tibble", {
  expect_is(l_sample_n_key, "tbl")
  expect_is(l_sample_frac_key, "tbl")
})

classes <- function(x) purrr::map_chr(x, class)

test_that("Returns correct classes", {
  expect_equal(classes(l_sample_n_key), classes(wages))
  expect_equal(classes(l_sample_frac_key), classes(wages))
})