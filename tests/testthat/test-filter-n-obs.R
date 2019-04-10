context("test-filter-n-obs")

wages_gt_10 <- wages %>% filter_n_obs(id = id, filter = l_n_obs > 10)

wages_et_2 <- wages %>% filter_n_obs(id = id, filter = l_n_obs == 2)

wages_gte_10 <-
  wages %>% filter_n_obs(id = id, filter = l_n_obs >= 10)

wages_lte_2 <-
  wages %>% filter_n_obs(id = id, filter = l_n_obs <= 2)


test_that("correct number of observations are returned", {
  expect_equal(nrow(wages_gt_10), 1105)
  expect_equal(nrow(wages_et_2), 78)
  expect_equal(nrow(wages_gte_10), 2235)
  expect_equal(nrow(wages_lte_2), 116)
})

test_that("correct number of columns are returned", {
  expect_equal(ncol(wages_gt_10), ncol(wages) + 1)
  expect_equal(ncol(wages_et_2), ncol(wages) + 1)
  expect_equal(ncol(wages_gte_10), ncol(wages) + 1)
  expect_equal(ncol(wages_lte_2), ncol(wages) + 1)
})

test_that("l_n_obs is added to the dataframe",{
  expect_equal(names(wages_gt_10),
               c(names(wages)[1],
                 "l_n_obs",
                 names(wages)[2:ncol(wages)]))
})

test_that("is a tibble", {
  expect_is(wages_et_2, "tbl")
  expect_is(wages_gt_10, "tbl")
  expect_is(wages_gte_10, "tbl")
  expect_is(wages_lte_2, "tbl")
})