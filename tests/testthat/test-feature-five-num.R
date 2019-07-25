wages_five_num <- wages %>%
  features(ln_wages, feat_five_num)

test_that("feat_five_num returns the right names", {
  expect_equal(names(wages_five_num),
               c("id", "min", "q25", "med", "q75", "max"))
})

test_that("feat_five_num returns the right dimensions", {
  expect_equal(dim(wages_five_num),
               c(888, 6))
})

library(dplyr)
test_that("feat_five_num returns all ids", {
  expect_equal(n_distinct(wages_five_num$id), 888)
})
