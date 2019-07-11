context("test-sample-n-frac-obs")

l_sample_n_keys <- sample_n_keys(.data = wages_ts, 
                                 key = id,
                                 size = 10)

l_sample_frac_keys <- sample_frac_keys(.data = wages_ts,
                                     key = id,
                                     size = 0.11)

test_that("correct number of columns returned",{
  expect_equal(ncol(l_sample_n_keys), ncol(wages_ts))
  expect_equal(ncol(l_sample_frac_keys), ncol(wages_ts))
})

test_that("correct number of ids returned",{
  expect_equal(dplyr::n_distinct(l_sample_n_keys$id), 10)
  expect_equal(dplyr::n_distinct(l_sample_frac_keys$id), 98)
})

test_that("correct names returned", {
  expect_equal(names(l_sample_n_keys), names(wages_ts))
  expect_equal(names(l_sample_frac_keys), names(wages_ts))
})

test_that("Returns a tibble", {
  expect_is(l_sample_n_keys, "tbl")
  expect_is(l_sample_frac_keys, "tbl")
})

classes <- function(x) purrr::map_chr(x, class)

test_that("Returns correct classes", {
  expect_equal(classes(l_sample_n_keys), classes(wages_ts))
  expect_equal(classes(l_sample_frac_keys), classes(wages_ts))
})
