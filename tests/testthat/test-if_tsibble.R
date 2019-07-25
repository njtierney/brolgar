test_that("test_if_tsibble works", {
  expect_silent(test_if_tsibble(wages))
  expect_error(test_if_tsibble(iris))
})
