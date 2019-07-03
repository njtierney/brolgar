context("test-stratify-key")

stratified_wages <- stratify_key(wages, 
                                 key = id, 
                                 n_strata = 10)

stratified_wages

test_that("correct number of observations are returned", {
  expect_equal(nrow(stratified_wages), nrow(wages))
})

test_that("correct number of columns are returned", {
  expect_equal(ncol(stratified_wages), ncol(wages)+1)
})

test_that(".strata is added to the dataframe",{
  expect_equal(names(stratified_wages), 
               c(names(stratified_wages)[1],
                 ".strata",
                 names(wages)[2:ncol(wages)]))
})

test_that("is a tibble", {
  expect_is(stratified_wages, class = "tbl")
})