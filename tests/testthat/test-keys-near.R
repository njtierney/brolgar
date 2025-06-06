# Return observations closest to the five number summary of ln_wages
summarise_ln_wages <- keys_near(.data = wages, var = ln_wages)

# Specify your own list of summaries
l_ranges <- list(
  min = b_min,
  range_diff = b_range_diff,
  max = b_max,
  iqr = b_iqr
)

summarise_slope <- wages %>%
  key_slope(formula = ln_wages ~ xp) %>%
  keys_near(key = id, var = .slope_xp)

summarise_ln_wages
summarise_slope

test_that("keys_near returns the same dimension and names etc", {
  skip_on_cran()
  skip_on_os("linux")
  expect_snapshot(summarise_ln_wages)
  expect_snapshot(summarise_slope)
})

summarised_slop_add_data <- dplyr::left_join(
  summarise_slope,
  wages,
  by = "id"
)

plot_stat <- ggplot(
  summarised_slop_add_data,
  aes(
    x = xp,
    y = ln_wages,
    group = id
  )
) +
  geom_line(
    data = wages,
    colour = "grey50",
    alpha = 0.5
  ) +
  geom_line(
    aes(colour = stat)
  )

test_that("keys_near returns a similar plot", {
  skip_on_ci()
  vdiffr::expect_doppelganger(
    "stat_plot",
    plot_stat
  )
})
