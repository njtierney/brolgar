wages_three_num <- wages %>%
  features(ln_wages, feat_three_num)

test_that("feat_three_num returns the right names", {
  expect_equal(names(wages_three_num),
               c("id", "min", "med", "max"))
})

test_that("feat_three_num returns the right dimensions", {
  expect_equal(dim(wages_three_num),
               c(888, 4))
})

library(dplyr)
test_that("feat_three_num returns all ids", {
  expect_equal(n_distinct(wages_three_num$id), 888)
})
