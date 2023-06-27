test_that("Basic ms_synthesize() works", {
  skip_if_no_key()
  # Returns raw bytes
  res <- ms_synthesize("Hello world")
  # Convert raw bytes to character
  res_processed <- rawToChar(res, multiple = TRUE)

  expect_equal(res_processed[1], "R")
  expect_equal(res_processed[1] != "", TRUE)
  expect_equal(res_processed[9], "W")
  expect_equal(res_processed[9] != "", TRUE)
})

test_that("Error: Wrong region", {
  skip_if_no_key()

  # Wrong region
  expect_error(suppressWarnings(ms_synthesize("Hello world", region = "westus9")))
  expect_error(suppressWarnings(ms_synthesize("Hello world", region = "easttus9")))
})


