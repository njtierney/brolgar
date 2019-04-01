context("test-l-d1")

df_l_d1 <- l_d1(wages, "id", "lnw")

test_that("l_mean returns the right dimensions", {
  expect_equal(dim(df_l_d1),
               c(888, 2))
})

test_that("l_mean returns the right names", {
  expect_equal(names(df_l_d1),
               c("id", "m"))
})

test_that("l_mean returns a data.frame", {
  expect_is(df_l_d1, 
            class = c("data.frame", "tibble"))
})

test_that("l_mean returns correct classes", {
  expect_equal(purrr::map_chr(df_l_d1, class),
               c(id = "integer", m = "numeric"))
})
