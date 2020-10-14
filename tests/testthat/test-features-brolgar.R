wages_brolgar <- wages %>%
  features(ln_wages, feat_brolgar)

test_that("feat_brolgar returns the right names", {
  expect_equal(names(wages_brolgar),
               c("id",
                 "min",
                 "max",
                 "median",
                 "mean",
                 "q25",
                 "q75",
                 "range1",
                 "range2",
                 "range_diff",
                 "sd",
                 "var",
                 "mad",
                 "iqr",
                 "increase",
                 "decrease",
                 "unvary",
                 "diff_min",
                 "diff_q25",
                 "diff_median",
                 "diff_mean",
                 "diff_q75",
                 "diff_max",
                 "diff_var",
                 "diff_sd",
                 "diff_iqr"
                 ))
})


test_that("feat_brolgar returns the right dimensions", {
  expect_equal(dim(wages_brolgar),
               c(888, 26))
})

library(dplyr)
test_that("feat_brolgar returns all ids", {
  expect_equal(n_distinct(wages_brolgar$id), 888)
})
