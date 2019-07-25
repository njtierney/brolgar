wages_spread <- wages %>%
  features(ln_wages, feat_spread)

test_that("feat_spread returns the right names", {
  expect_equal(names(wages_spread),
               c("id", "var", "sd", "mad", "iqr"))
})

test_that("feat_spread returns the right dimensions", {
  expect_equal(dim(wages_spread),
               c(888, 5))
})

library(dplyr)
test_that("feat_spread returns all ids", {
  expect_equal(n_distinct(wages_spread$id), 888)
})
