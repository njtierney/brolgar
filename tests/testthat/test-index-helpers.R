test_that("index regular returns logical", {
  expect_type(index_regular(pisa, year), "logical")
})

test_that("index regular fails when non data.frame provided", {
  expect_error(index_regular(matrix(0), 1))
})

test_that("index regular fails when column doesn't exist", {
  expect_error(index_regular(pisa, wat))
})

test_that("index summary returns summaryDefault", {
  expect_s3_class(index_summary(pisa, year), "summaryDefault")
  expect_type(index_summary(pisa, year), "double")
})

test_that("index summary fails when non data.frame provided", {
  expect_error(index_summary(matrix(0), 1))
})

test_that("index summary fails when column doesn't exist", {
  expect_error(index_summary(pisa, wat))
})
