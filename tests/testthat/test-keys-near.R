# Return observations closest to the five number summary of ln_wages
summarise_ln_wages <- keys_near(.data = wages, var = ln_wages)

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

test_that("keys_near returns the same dimension and names etc", {
  expect_snapshot(summarise_ln_wages)
  expect_snapshot(summarise_slope)
})
