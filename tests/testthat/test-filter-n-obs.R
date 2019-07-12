context("test-filter-n-obs")

wages_gt_10 <- filter_n_obs(wages_ts, filter = n_obs > 10)

wages_et_2 <- filter_n_obs(wages_ts, filter = n_obs == 2)

wages_gte_10 <- wages_ts %>% filter_n_obs(filter = n_obs >= 10)

wages_lte_2 <- wages_ts %>% filter_n_obs(filter = n_obs <= 2)


test_that("correct number of observations are returned", {
  expect_equal(nrow(wages_gt_10), 1105)
  expect_equal(nrow(wages_et_2), 78)
  expect_equal(nrow(wages_gte_10), 2235)
  expect_equal(nrow(wages_lte_2), 116)
})

test_that("correct number of columns are returned", {
  expect_equal(ncol(wages_gt_10), ncol(wages_ts) + 1)
  expect_equal(ncol(wages_et_2), ncol(wages_ts) + 1)
  expect_equal(ncol(wages_gte_10), ncol(wages_ts) + 1)
  expect_equal(ncol(wages_lte_2), ncol(wages_ts) + 1)
})

test_that("n_key_obs is added to the dataframe",{
  expect_equal(names(wages_gt_10),
               c(names(wages_ts), "n_obs")
  )
})

test_that("is a tibble", {
  expect_is(wages_et_2, "tbl")
  expect_is(wages_gt_10, "tbl")
  expect_is(wages_gte_10, "tbl")
  expect_is(wages_lte_2, "tbl")
})
