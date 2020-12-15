test_that("Default functions work", {
  expect_error(c(1, 2) %if_empty_string% NULL)
  expect_error(c("", "") %if_empty_string% NULL)
  
  expect_identical("hi" %if_empty_string% "bye", "hi")
  expect_identical("" %if_empty_string% "bye", "bye")
})
