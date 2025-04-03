# function to use inside testthat
add_new_names <- function(data, x) {
  c(
    tsibble::key_vars(data),
    tsibble::index_var(data),
    x,
    tsibble::measured_vars(data)
  )
}

wages_test <- wages %>% add_n_obs()
wages_gt_10 <- filter(wages_test, n_obs > 10)

wages_et_2 <- filter(wages_test, n_obs == 2)

wages_gte_10 <- filter(wages_test, n_obs >= 10)

wages_lte_2 <- filter(wages_test, n_obs <= 2)


test_that("n_obs works with names", {
  expect_equal(as.numeric(n_obs(wages)), nrow(wages))
  expect_equal(n_obs(wages), c(n_obs = nrow(wages)))
  expect_equal(n_obs(wages, names = FALSE), nrow(wages))
})

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

test_that("n_obs is added to the dataframe", {
  expect_equal(names(wages_gt_10), add_new_names(wages, "n_obs"))
})

test_that("is a tibble", {
  expect_s3_class(wages_et_2, "tbl")
  expect_s3_class(wages_gt_10, "tbl")
  expect_s3_class(wages_gte_10, "tbl")
  expect_s3_class(wages_lte_2, "tbl")
})
