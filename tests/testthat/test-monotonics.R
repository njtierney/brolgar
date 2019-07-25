vec_inc <- c(1:10)
vec_dec<- c(10:1)
vec_ran <- c(sample(1:10))
vec_flat <- rep.int(1,10)

test_that("increasing correctly guesses", {
  expect_true(increasing(vec_inc))
  expect_false(increasing(vec_dec))
  expect_false(increasing(vec_ran))
  expect_false(increasing(vec_flat))
  expect_false(increasing(1))
})

test_that("decreasing correctly guesses", {
  expect_false(decreasing(vec_inc))
  expect_true(decreasing(vec_dec))
  expect_false(decreasing(vec_ran))
  expect_false(decreasing(vec_flat))
  expect_false(decreasing(1))
})

test_that("unvarying correctly guesses", {
  expect_false(unvarying(vec_inc))
  expect_false(unvarying(vec_dec))
  expect_false(unvarying(vec_ran))
  expect_true(unvarying(vec_flat))
  expect_false(unvarying(1))
})

test_that("monotonic correctly guesses", {
  expect_true(monotonic(vec_inc))
  expect_true(monotonic(vec_dec))
  expect_false(monotonic(vec_ran))
  expect_false(monotonic(vec_flat))
  expect_false(monotonic(1))
})

wages_monotonic <- wages %>% features(ln_wages, feat_monotonic)

test_that("wages_monotonic produces output 0 or 1",{
  expect_equal(max(rowSums(wages_monotonic[ , 2:4])), 1)
  expect_false(any(rowSums(wages_monotonic[ , 2:4]) > 1))
})

