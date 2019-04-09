context("test-add-k-groups")

k_wages <- add_k_groups(wages, id, k = 10)

k_wages

test_that("correct number of observations are returned", {
  expect_equal(nrow(k_wages), nrow(wages))
})

test_that("correct number of columns are returned", {
  expect_equal(ncol(k_wages), ncol(wages)+1)
})

test_that(".rand_id is added to the dataframe",{
  expect_equal(names(k_wages), c(names(k_wages)[1],
                                 ".rand_id",
                                 names(wages)[2:ncol(wages)]))
})

test_that("is a tibble", {
  expect_is(k_wages, class = "tbl")
})