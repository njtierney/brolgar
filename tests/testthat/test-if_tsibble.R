ts_wages <- tsibble::as_tsibble(x = wages, 
                                key = id,
                                index = exper,
                                regular = FALSE)

test_that("test_if_tsibble works", {
  expect_silent(test_if_tsibble(ts_wages))
  expect_error(test_if_tsibble(wages))
})
