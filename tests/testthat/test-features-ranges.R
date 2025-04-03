wages_ranges <- wages %>%
  features(ln_wages, feat_ranges)

test_that("feat_ranges returns the right names", {
  expect_equal(names(wages_ranges), c("id", "min", "max", "range_diff", "iqr"))
})

test_that("feat_ranges returns the right dimensions", {
  expect_equal(dim(wages_ranges), c(888, 5))
})

library(dplyr)
test_that("feat_ranges returns all ids", {
  expect_equal(n_distinct(wages_ranges$id), 888)
})
