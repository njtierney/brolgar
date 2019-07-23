context("test-stratify-key")

wages_test <- sample_frac_keys(wages_ts, size = 0.10)

wages_strat <- stratify_keys(wages_test, n_strata = 10)

library(tsibble)
wages_strat_along <-  wages_test %>%
  stratify_keys(n_strata = 10,
                along = unemploy_rate,
                fun = median)

test_that("correct number of observations are returned", {
  expect_equal(nrow(wages_strat), nrow(wages_test))
  expect_equal(nrow(wages_strat_along), nrow(wages_test))
})

test_that("correct number of columns are returned", {
  expect_equal(ncol(wages_strat), ncol(wages_test) + 1)
  expect_equal(ncol(wages_strat_along), ncol(wages_test) + 1)
})

test_that(".strata is added to the dataframe",{
  expect_equal(names(wages_strat), 
               c(names(wages_test), ".strata"))
  expect_equal(names(wages_strat_along), 
               c(names(wages_test), 
                 ".strata"))
})

test_that("is a tsibble", {
  expect_is(wages_strat, class = "tbl_ts")
  expect_is(wages_strat_along, class = "tbl_ts")
})

wages_strat_along_sum <- wages_strat_along %>%
  as_tibble() %>%
  group_by(.strata) %>%
  summarise_at(vars(unemploy_rate),
               list(mean = mean),
               na.rm = TRUE)

test_that("stratify_keys with along returns strata that are decreasing",{
  expect_true(decreasing(wages_strat_along_sum$mean))
})

# ggplot(wages_strat_sum,
#        aes(x = .strata,
#              y = .slope_xp_mean)) + 
#   geom_point()
