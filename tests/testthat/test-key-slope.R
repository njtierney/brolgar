context("key_slope formula")

test_that("key_slope does not handle character input", {
  expect_error(key_slope(heights, "height_cm ~ year"))
})

test_that("key_slope does not fail", {
  expect_s3_class(key_slope(heights, height_cm ~ year), "tbl_df")
})

test_that("key_slope fails when given non-formula", {
  expect_error(key_slope(heights, "height_cm year"))
  expect_error(key_slope(heights, height_cm + .))
  expect_error(key_slope(heights, height_cm))
})

test_that("add_key_slope does not handle character input", {
  expect_error(add_key_slope(heights, "height_cm ~ year"))
})

test_that("add_key_slope does not fail", {
  expect_s3_class(add_key_slope(heights, height_cm ~ year), "tbl_df")
})


test_that("add_key_slope fails when given non-formula", {
  expect_error(add_key_slope(heights, "height_cm year"))
  expect_error(add_key_slope(heights, height_cm + .))
  expect_error(add_key_slope(heights, height_cm))
})
