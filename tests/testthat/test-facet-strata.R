library(ggplot2)
library(dplyr)
set.seed(2019 - 07 - 23 - 1835)
gg_facet_strata <- ggplot(
  heights,
  aes(x = year, y = height_cm, group = country)
) +
  geom_line() +
  facet_strata()

set.seed(2019 - 07 - 23 - 1836)
gg_facet_strata_along <- wages %>%
  sample_frac_keys(0.1) %>%
  key_slope(ln_wages ~ xp) %>%
  right_join(wages, ., by = "id") %>%
  ggplot(aes(x = xp, y = ln_wages)) +
  geom_line(aes(group = id)) +
  geom_smooth(method = "lm") +
  facet_strata(along = .slope_xp)

test_that("facet_strata works without along", {
  skip_on_cran()
  skip_on_ci()
  vdiffr::expect_doppelganger("gg_facet_strata", gg_facet_strata)
})


test_that("facet_strata works with along", {
  skip_on_cran()
  skip_on_ci()
  vdiffr::expect_doppelganger("gg_facet_strata_along", gg_facet_strata_along)
})
