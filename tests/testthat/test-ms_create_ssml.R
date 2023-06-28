test_that("ms_create_ssml() works", {
  ssml <- ms_create_ssml("hey I really like things & dogs", escape = TRUE)
  expect_type(ssml, "character")
})
