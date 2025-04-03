l_sample_n_keys <- sample_n_keys(.data = wages, size = 10)

l_sample_frac_keys <- sample_frac_keys(.data = wages, size = 0.11)

test_that("fails when size > 0 given", {
  expect_error(sample_frac_keys(.data = wages, size = 2))
  expect_equal(dim(sample_frac_keys(.data = wages, size = 1)), c(6402, 9))
})

test_that("correct number of columns returned", {
  expect_equal(ncol(l_sample_n_keys), ncol(wages))
  expect_equal(ncol(l_sample_frac_keys), ncol(wages))
})

test_that("correct number of ids returned", {
  expect_equal(dplyr::n_distinct(l_sample_n_keys$id), 10)
  expect_equal(dplyr::n_distinct(l_sample_frac_keys$id), 98)
})

test_that("correct names returned", {
  expect_equal(names(l_sample_n_keys), names(wages))
  expect_equal(names(l_sample_frac_keys), names(wages))
})

test_that("Returns a tibble", {
  expect_s3_class(l_sample_n_keys, "tbl")
  expect_s3_class(l_sample_frac_keys, "tbl")
})

classes <- function(x) purrr::map_chr(x, class)

test_that("Returns correct classes", {
  expect_equal(classes(l_sample_n_keys), classes(wages))
  expect_equal(classes(l_sample_frac_keys), classes(wages))
})
