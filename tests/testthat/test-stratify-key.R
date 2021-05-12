context("test-stratify-key")

wages_test <- sample_frac_keys(wages, size = 0.10)

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

test_that("stratify_keys with along returns strata that decrease on average",{
  expect_true(mean(diff(wages_strat_along_sum$mean)) < 0)
})

test_that("The strata are unique within each id", {
  n_strata_and_id <- wages_test %>%
    stratify_keys(n_strata = 4) %>% 
    select(id, ln_wages, .strata) %>% 
    as_tibble() %>% 
    distinct(id, .strata) %>% 
    nrow()
  
  expect_equal(n_strata_and_id, tsibble::n_keys(wages_test))
})

test_that("possible_strata returns the same length as the number of keys",{
  how_many_possible_strata <- length(possible_strata(wages_test, 2))
  expect_equal(how_many_possible_strata, n_keys(wages_test))
})


test_that("The number of groups in each strata equals the number of keys", {
  
  wages_groups <- wages_test %>%
    sample_n_keys(12) %>%
    select(id) %>% 
    stratify_keys(n_strata = 4) %>% 
    as_tibble() %>%
    group_by(.strata) %>%
    summarise(n = n_distinct(id)) %>% 
    pull(n) %>% 
    sum()
  expect_equal(tsibble::n_keys(sample_n_keys(wages_test, 12)), wages_groups)
})


strata_equal_1 <- wages_test %>%
  sample_n_keys(12) %>%
  stratify_keys(n_strata = 4) %>%
  as_tibble() %>%
  group_by(.strata) %>%
  summarise(n = n_distinct(id)) 

strata_equal_2 <- wages_test %>%
  sample_n_keys(24) %>%
  stratify_keys(n_strata = 4) %>%
  as_tibble() %>%
  group_by(.strata) %>%
  summarise(n = n_distinct(id)) 

strata_equal_3 <- wages_test %>%
  sample_n_keys(25) %>%
  stratify_keys(n_strata = 4) %>%
  as_tibble() %>%
  group_by(.strata) %>%
  summarise(n = n_distinct(id)) 

test_that("stratify_keys returns the same number of keys per strata", {
  expect_true(all(strata_equal_1$n == 3))
  expect_true(all(strata_equal_2$n == 6))
  expect_true(all(strata_equal_3$n %in% c(6,7,6,6)))
})


# need to add tests for each


# ggplot(wages_strat_sum,
#        aes(x = .strata,
#              y = .slope_xp_mean)) + 
#   geom_point()
