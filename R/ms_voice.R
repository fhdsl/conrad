# When voice is provided in ms_synthesize()
ms_use_voice <- function(voice,
                         api_key = NULL,
                         region = "westus") {
  stopifnot(length(voice) == 1 & is.character(voice))

  # Get a full list of voices for a specific region
  df <- ms_list_voice(api_key = api_key, region = region)
  # Check if provided voice is in this list
  keep <- (df$Name %in% voice) | (df$ShortName %in% voice)
  if (!any(keep)) {
    stop(paste0("Voice is not supported in region:", region))
  }
  df <- df[keep, , drop = FALSE]
  df <- df[1, , drop = FALSE]
  # Extract Gender, Full name, and Language
  res <- list(gender = df$Gender,
              full_name = df$Name,
              language = df$Locale)

  res
}

# When voice is NOT provided in ms_synthesize()
ms_choose_voice <- function(api_key = NULL,
                            gender = c("Female", "Male"),
                            language =  "en-US",
                            region = "westus",
                            token = NULL) {
  stopifnot(is.character(language) & is.character(gender))
  gender <- match.arg(gender)

  # Get a full list of voices for a specific region
  df <- ms_list_voice(api_key = api_key, region = region)
  # Filter for provided language and gender
  df <- df[df$Locale == language, ]
  df <- df[df$Gender == gender, ]
  # By default, use first voice
  df <- df[1, ]

  res <- list(full_name = df$Name,
              language = df$Locale,
              gender =  df$Gender)

  res
}

