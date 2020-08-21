# Return observations closest to the five number summary of ln_wages
context("keys near")
summarise_ln_wages <- wages %>%
  keys_near(var = ln_wages)

# Specify your own list of summaries
l_ranges <- list(min = b_min,
                 range_diff = b_range_diff,
                 max = b_max,
                 iqr = b_iqr)

summarise_slope <- wages %>%
  key_slope(formula = ln_wages ~ xp) %>%
  keys_near(key = id,
            var = .slope_xp)

summarise_ln_wages
summarise_slope

test_that("keys_near returns the right names", {
  expect_equal(names(summarise_ln_wages),
               c("id", "ln_wages", "stat", "stat_value", "stat_diff"))
  expect_equal(names(summarise_slope),
               c("id", ".slope_xp", "stat", "stat_value", "stat_diff"))
})

test_that("keys_near returns the right dimension", {
  expect_equal(dim(summarise_ln_wages),
               c(71, 5))
  expect_equal(dim(summarise_slope),
               c(6,5))
})

library(dplyr)

test_that("keys_near returns unique ids", {
  expect_equal(n_distinct(summarise_ln_wages$id), 69)
  expect_equal(n_distinct(summarise_slope$id), 6)
})
