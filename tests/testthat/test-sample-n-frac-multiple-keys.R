library(tsibble)
library(brolgar)
library(dplyr)
skip_if_not_installed("tsibbledata")
library(tsibbledata)

data("aus_retail")

# will fail
test_that("multiple keys doesn't fail", {
  expect_equal(ncol(sample_n_keys(aus_retail, size = 10)), 5)
  expect_gt(nrow(sample_n_keys(aus_retail, size = 10)), 1)

  expect_equal(ncol(sample_frac_keys(aus_retail, size = 0.11)), 5)
  expect_gt(nrow(sample_frac_keys(aus_retail, size = 0.11)), 1)
})

test_that("fails when size > 0 given", {
  expect_error(sample_frac_keys(aus_retail, size = 2))
  expect_equal(dim(sample_frac_keys(aus_retail, size = 1)), dim(aus_retail))
})

aus_retail_sample10 <- sample_n_keys(aus_retail, size = 10)

# I'm not really sure what I would expect these numbers to be?
aus_retail_sample10 %>% pull(State) %>% n_distinct()
aus_retail_sample10 %>% pull(Industry) %>% n_distinct()

sample_n_keys(wages, size = 10)

sample_n_keys_retail_nkeys <- sample_n_keys(aus_retail, size = 10)
sample_frac_keys_retail_nkeys <- sample_frac_keys(aus_retail, size = 0.11)
n_keys(sample_frac_keys_retail_nkeys)


test_that("correct number of columns returned", {
  expect_equal(ncol(sample_n_keys_retail_nkeys), ncol(aus_retail))
  expect_equal(ncol(sample_frac_keys_retail_nkeys), ncol(aus_retail))
})

aus_retail_keys <- tsibble::key_vars(aus_retail)

test_that("correct number of keys returned", {
  expect_equal(n_keys(sample_n_keys_retail_nkeys), 10)
  expect_equal(n_keys(sample_frac_keys_retail_nkeys), 17)
})

test_that("correct names returned", {
  expect_equal(names(sample_n_keys_retail_nkeys), names(aus_retail))
  expect_equal(names(sample_frac_keys_retail_nkeys), names(aus_retail))
})

test_that("Returns a tibble", {
  expect_s3_class(sample_n_keys_retail_nkeys, "tbl")
  expect_s3_class(sample_frac_keys_retail_nkeys, "tbl")
})

classes <- function(x) purrr::map(x, class)

test_that("Returns correct classes", {
  expect_equal(classes(sample_n_keys_retail_nkeys), classes(aus_retail))
  expect_equal(classes(sample_frac_keys_retail_nkeys), classes(aus_retail))
})
