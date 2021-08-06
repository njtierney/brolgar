x <- 1:100
library(dplyr)

x <- 1:10

test_that("`near_between()` works on a vector", {
  expect_equal(near_between(x, from = 0.4, to = 0.6), 
               c(rep(FALSE, 4), TRUE, TRUE, rep(FALSE, 4)))
  expect_equal(near_between(x, from = 0.1, to = 0.3), 
               c(FALSE, TRUE, TRUE, rep(FALSE, 7)))
})

wages_feat <- wages %>%
  features(ln_wages, list(min = min))

wages_feat_near_btn <- wages_feat %>%
  filter(near_between(x = min,
                      from = 0.4, 
                      to = 0.6))

test_that("`near_between()` works on a data.frame",{
  expect_s3_class(wages_feat_near_btn, "data.frame")
  expect_lte(nrow(wages_feat_near_btn), nrow(wages_feat))
  expect_equal(ncol(wages_feat_near_btn), ncol(wages_feat))
})

test_that("`near_middle()` works on a vector", {
  expect_equal(near_middle(x = x, middle = 0.5, within = 0.2), 
               c(rep(FALSE, 4), TRUE, TRUE, rep(FALSE, 4)))
  expect_equal(near_middle(x = x, middle = 0.2, within = 0.1), 
               c(FALSE, FALSE, TRUE, rep(FALSE, 7)))
})

wages_feat_near_middle <- wages_feat %>%
  filter(near_middle(x = min,
                     middle = 0.5, 
                     within = 0.2))

test_that("`near_middle()` works on a data.frame", {
  expect_s3_class(wages_feat_near_middle, "data.frame")
  expect_lte(nrow(wages_feat_near_middle), nrow(wages_feat))
  expect_equal(ncol(wages_feat_near_middle), ncol(wages_feat))
})


test_that("`near_quantile()` works on a vector", {
  expect_equal(near_quantile(x, probs = 0.5, tol = 0.01), 
               rep(FALSE, 10))
  expect_equal(near_quantile(x, probs = 0.5, tol = 0.5), 
               c(rep(FALSE, 4), TRUE, TRUE, rep(FALSE, 4)))
  expect_equal(near_quantile(x, probs = 0.25, tol = 0.01), 
               rep(FALSE, 10))
  expect_equal(near_quantile(x, probs = 0.25, tol = 0.5), 
               c(rep(FALSE, 2), TRUE, rep(FALSE, 7)))
  expect_equal(near_quantile(x, probs = c(0.25, 0.75), tol = 0.01), 
               rep(FALSE, 10))
  expect_equal(near_quantile(x, probs = c(0.25, 0.75), tol = 0.5), 
               c(rep(FALSE, 2), TRUE, rep(FALSE, 4), TRUE, FALSE, FALSE))
})

wages_q1 <- wages %>%
  features(ln_wages, list(min = min)) %>%
  filter(near_quantile(
    x = min,
    probs = 0.5, 
    tol = 0.01
  ))

wages_q2 <- wages %>%
  features(ln_wages, list(min = min)) %>%
  filter(near_quantile(
    x = min,
    probs = c(0.25, 0.5, 0.75), 
    tol = 0.01
  )) 

test_that("`near_quantile()` works on a data.frame", {
  expect_s3_class(wages_q1, "data.frame")
  expect_s3_class(wages_q2, "data.frame")
  expect_lte(nrow(wages_q1), nrow(wages_feat))
  expect_lte(nrow(wages_q2), nrow(wages_feat))
  expect_equal(ncol(wages_q1), ncol(wages_feat))
  expect_equal(ncol(wages_q2), ncol(wages_feat))
})

x <- 1:10
y <- 5:14
z <- 16:25
a <- -1:-5
b <- -1

test_that("`nearest_lgl()` works for vectors", {
  expect_equal(nearest_lgl(x, y), c(rep(TRUE,6), rep(FALSE,4)))
  expect_equal(nearest_lgl(y, x), c(rep(FALSE,4), rep(TRUE,6)))
  expect_equal(nearest_lgl(x, z), c(TRUE, rep(FALSE, 9)))
  expect_equal(nearest_lgl(z, x), c(rep(FALSE, 9), TRUE))
  expect_equal(nearest_lgl(x, a), c(TRUE, rep(FALSE, 4)))
  expect_equal(nearest_lgl(a, x), c(TRUE, rep(FALSE, 9)))
  expect_equal(nearest_lgl(x, b), TRUE)
  expect_equal(nearest_lgl(b, x), c(TRUE, rep(FALSE, 9)))
})

wages_near_min <- wages %>%
  filter(nearest_lgl(min(ln_wages), ln_wages))

wages_near_fivenum <- wages %>%
  filter(nearest_lgl(fivenum(ln_wages), ln_wages))

test_that("`nearest_lgl()` works for data.frames", {
  expect_s3_class(wages_near_min, "data.frame")
  expect_s3_class(wages_near_fivenum, "data.frame")
  expect_lte(nrow(wages_near_min), nrow(wages))
  expect_lte(nrow(wages_near_fivenum), nrow(wages))
  expect_equal(ncol(wages_near_min), ncol(wages))
  expect_equal(ncol(wages_near_fivenum), ncol(wages))
  expect_equal(nrow(wages_near_min), 1)
  expect_equal(nrow(wages_near_fivenum), 5)
})


test_that("`nearest_qt_lgl()` works for vectors", {
  expect_equal(nearest_qt_lgl(x, c(0.5)), 
               c(rep(FALSE, 4), TRUE, rep(FALSE, 5)))
  expect_equal(sum(nearest_qt_lgl(x, c(0.5))), 1)
  expect_equal(nearest_qt_lgl(x, c(0.25, 0.5, 0.75)), 
               c(FALSE, FALSE, 
                 TRUE, FALSE, 
                 TRUE, 
                 FALSE, FALSE, 
                 TRUE, 
                 FALSE, FALSE))
  expect_equal(sum(nearest_qt_lgl(x, c(0.25, 0.5, 0.75))), 3) 
  expect_equal(nearest_qt_lgl(x, c(0.1, 0.5, 0.9)), 
               c(FALSE, TRUE,
                 FALSE, FALSE,
                 TRUE,
                 rep(FALSE, 3),
                 TRUE, 
                 FALSE))
  expect_equal(sum(nearest_qt_lgl(x, c(0.1, 0.5, 0.9))), 3)
})

wages_near_qt_1 <- wages %>%
  filter(nearest_qt_lgl(ln_wages, c(0.5)))

wages_near_qt_3 <- wages %>%
  filter(nearest_qt_lgl(ln_wages, c(0.1, 0.5, 0.9)))

test_that("`nearest_qt_lgl()` works for data.frames", {
  expect_s3_class(wages_near_qt_1, "data.frame")
  expect_s3_class(wages_near_qt_3, "data.frame")
  expect_lte(nrow(wages_near_qt_1), nrow(wages))
  expect_lte(nrow(wages_near_qt_3), nrow(wages))
  expect_equal(ncol(wages_near_qt_1), ncol(wages))
  expect_equal(ncol(wages_near_qt_3), ncol(wages))
  expect_equal(nrow(wages_near_qt_1), 1)
  expect_equal(nrow(wages_near_qt_3), 3)
})