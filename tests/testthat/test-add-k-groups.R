context("test-stratify-key")

stratified_wages <- stratify_keys(wages_ts, 
                                  key = id, 
                                  n_strata = 10)

stratified_wages

test_that("correct number of observations are returned", {
  expect_equal(nrow(stratified_wages), nrow(wages_ts))
})

test_that("correct number of columns are returned", {
  expect_equal(ncol(stratified_wages), ncol(wages_ts) + 1)
})

test_that(".strata is added to the dataframe",{
  expect_equal(names(stratified_wages), 
               c(names(wages_ts), ".strata"))
})

test_that("is a tibble", {
  expect_is(stratified_wages, class = "tbl")
})
