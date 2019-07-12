vec_inc <- c(1:10)
vec_dec<- c(10:1)
vec_ran <- c(sample(1:10))
vec_flat <- rep.int(1,10)

test_that("increasing correctly guesses", {
  expect_true(increasing(vec_inc))
  expect_false(increasing(vec_dec))
  expect_false(increasing(vec_ran))
  expect_false(increasing(vec_flat))
})

test_that("decreasing correctly guesses", {
  expect_false(decreasing(vec_inc))
  expect_true(decreasing(vec_dec))
  expect_false(decreasing(vec_ran))
  expect_false(decreasing(vec_flat))
})

test_that("unvarying correctly guesses", {
  expect_false(unvarying(vec_inc))
  expect_false(unvarying(vec_dec))
  expect_false(unvarying(vec_ran))
  expect_true(unvarying(vec_flat))
})

