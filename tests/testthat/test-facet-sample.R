library(ggplot2)
set.seed(2019-07-23-1900)
gg_facet_sample <- ggplot(heights,
                          aes(x = year,
                              y = height_cm,
                              group = country)) +
  geom_line() +
  facet_sample()

set.seed(2019-07-23-1901)
gg_facet_sample_alt <- ggplot(heights,
                              aes(x = year,
                                  y = height_cm,
                                  group = country)) +
  geom_line(colour = "red") +
  facet_sample(n_per_facet = 4,
               n_facets = 6)

test_that("facet_sample works",{
  skip_on_cran()
  skip_on_ci()
  vdiffr::expect_doppelganger("gg_facet_sample",
                              gg_facet_sample)
})


test_that("facet_sample works with different options",{
  skip_on_cran()
  skip_on_ci()
  vdiffr::expect_doppelganger("gg_facet_sample_alt",
                              gg_facet_sample_alt)
})

