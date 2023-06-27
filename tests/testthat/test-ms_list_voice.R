voice_list_names <- c("Name", "DisplayName", "LocalName",
                      "ShortName", "Gender", "Locale", "LocaleName")

test_that("ms_list_voice() returns a dataframe with voice information", {
  response_df <- ms_list_voice(region = "westus")
  response_df <- response_df[,1:7]

  # Check x is a data.frame
  expect_s3_class(response_df, "data.frame")
  # Check column names
  expect_named(response_df, voice_list_names)
})
