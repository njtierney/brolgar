wages_monotonic <- wages %>%
  features(ln_wages, feat_monotonic)

test_that("feat_monotonic returns the right names", {
  expect_equal(names(wages_monotonic),
               c("id",
                 "increase",
                 "decrease",
                 "unvary",
                 "monotonic"))
})


test_that("feat_monotonic returns the right dimensions", {
  expect_equal(dim(wages_monotonic),
               c(888, 5))
})

library(dplyr)
test_that("feat_monotonic returns all ids", {
  expect_equal(n_distinct(wages_monotonic$id), 888)
})
