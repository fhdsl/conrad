voice_names <- c("gender", "full_name", "language")

test_that("ms_voice() returns a list with appropriate names", {
  res <- ms_use_voice(voice = "Microsoft Server Speech Text to Speech Voice (en-US, JacobNeural)",
               region = "westus")
  # Check x is a data.frame
  expect_type(res, "list")
  # Check column names
  expect_named(res, voice_names)
})
