context("test-sample-n-frac-obs")

l_sample_n_keys <- sample_n_keys(.data = wages,
                                 size = 10)

l_sample_frac_keys <- sample_frac_keys(.data = wages,
                                     size = 0.11)

sample_n_keys_pisa <- sample_n_keys(.data = pisa,
                                    size = 10,
                                    key = country)

sample_frac_keys_pisa <- sample_frac_keys(.data = pisa,
                                          size = 0.11,
                                          key = country)

test_that("fails when size > 0 given", {
  expect_error(sample_frac_keys(.data = wages, size = 2))
  expect_equal(dim(sample_frac_keys(.data = wages, size = 1)), c(6402, 9))
  expect_error(sample_frac_keys(.data = pisa, size = 2, key = country))
  expect_equal(dim(sample_frac_keys(.data = pisa, size = 1, key = country)), 
               c(433, 11))
})

test_that("correct number of columns returned",{
  expect_equal(ncol(l_sample_n_keys), ncol(wages))
  expect_equal(ncol(l_sample_frac_keys), ncol(wages))
  expect_equal(ncol(sample_n_keys_pisa), ncol(pisa))
  expect_equal(ncol(sample_frac_keys_pisa), ncol(pisa))
})

test_that("correct number of ids returned",{
  expect_equal(dplyr::n_distinct(l_sample_n_keys$id), 10)
  expect_equal(dplyr::n_distinct(l_sample_frac_keys$id), 98)
  expect_equal(dplyr::n_distinct(sample_n_keys_pisa$country), 10)
  expect_equal(dplyr::n_distinct(sample_frac_keys_pisa$country), 11)
})

test_that("correct names returned", {
  expect_equal(names(l_sample_n_keys), names(wages))
  expect_equal(names(l_sample_frac_keys), names(wages))
  expect_equal(names(sample_n_keys_pisa), names(pisa))
  expect_equal(names(sample_frac_keys_pisa), names(pisa))
})

test_that("Returns a tibble", {
  expect_is(l_sample_n_keys, "tbl")
  expect_is(l_sample_frac_keys, "tbl")
  expect_is(sample_n_keys_pisa, "tbl")
  expect_is(sample_frac_keys_pisa, "tbl")
})

classes <- function(x) purrr::map_chr(x, class)

test_that("Returns correct classes", {
  expect_equal(classes(l_sample_n_keys), classes(wages))
  expect_equal(classes(l_sample_frac_keys), classes(wages))
  expect_equal(classes(sample_n_keys_pisa), classes(pisa))
  expect_equal(classes(sample_frac_keys_pisa), classes(pisa))
})
