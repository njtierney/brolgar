context("feature diff summary")

heights_diff_summary <- heights %>%
  features(year, feat_diff_summary)

test_that("feat_diff_summary returns the right names", {
  expect_equal(names(heights_diff_summary),
               c("country", 
                 "diff_min",
                 "diff_q25",
                 "diff_median",
                 "diff_mean",
                 "diff_q75",
                 "diff_max",
                 "diff_var",
                 "diff_sd",
                 "diff_iqr"))
})

test_that("feat_diff_summary returns the right dimensions", {
  expect_equal(dim(heights_diff_summary),
               c(144, 10))
})

test_that("feat_diff_summary returns all ids", {
  expect_equal(dplyr::n_distinct(heights_diff_summary$country), 144)
})
