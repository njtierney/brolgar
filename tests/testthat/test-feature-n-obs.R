wages_test <- sample_frac_keys(wages, 0.05)
df_n_obs <- features(wages_test, ln_wages, n_obs)
new_dims <- c(n_keys(wages_test), 2)

test_that("feature returns the right dimensions", {
  expect_equal(dim(df_n_obs), new_dims)
})

test_that("longnostic returns the right names", {
  expect_equal(names(df_n_obs), c("id", "n_obs"))
})

test_that("longnostic returns a tbl_df", {
  expect_s3_class(df_n_obs, class = c("tbl"))
})

test_that("longnostic returns correct classes", {
  expect_equal(classes(df_n_obs), c(id = "integer", n_obs = "integer"))
})
