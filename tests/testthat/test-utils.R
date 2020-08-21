test_that("pct works", {
  expect_equal(pct(0.1), c("q_10"))
  expect_equal(pct(0.2), c("q_20"))
  expect_equal(pct(0.3), c("q_30"))
  expect_equal(pct(0.99), c("q_99"))
})

q_vec <- c(1:100)

test_that("qtl works",  {
  expect_equal(as.numeric(qtl(q_vec, 0.25)), 
               quantile(q_vec, 0.25, names = FALSE))
  
  expect_equal(names(qtl(q_vec, 0.25)), 
               "q_25")
  
  expect_equal(as.numeric(qtl(q_vec, c(0.25,0.50))),
               quantile(q_vec, c(0.25,0.50), names = FALSE))
  
  expect_equal(names(qtl(q_vec, c(0.25,0.50))),
               c("q_25", "q_50"))
  
  expect_equal(as.numeric(qtl(q_vec, seq(0.25,0.5, by = 0.05))),
               quantile(q_vec, seq(0.25,0.5, by = 0.05), names = FALSE))
  
  expect_equal(names(qtl(q_vec, seq(0.25,0.5, by = 0.05))),
               c("q_25", "q_30", "q_35", "q_40", "q_45", "q_50"))

})

test_that("test_if_null returns different error messages",{
  expect_error(test_if_null(NULL))
  expect_error(test_if_null(NULL), regexp = "must not be NULL")
  expect_error(test_if_null(NULL,
                            message = "wat even is this"), 
               regexp = "even is this")
})
