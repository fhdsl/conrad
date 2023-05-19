#' Check if provided voice is supported in region
#'
#' @param voice Full voice name
#' @param api_key Microsoft Azure Cognitive Services API key
#' @param region Subscription region for API key. For more info, see
#' \url{https://learn.microsoft.com/en-us/azure/cognitive-services/speech-service/regions}
#'
#' @return List of gender, language, and full voice name
#' @export
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

#' Provide default voice when not provided
#'
#' @param api_key Microsoft Azure Cognitive Services API key
#' @param gender Sex of speaker
#' @param language Language to be spoken
#' @param region Subscription region for API key. For more info, see
#' \url{https://learn.microsoft.com/en-us/azure/cognitive-services/speech-service/regions}
#'
#' @return List of gender, language, and full voice name
#' @export
ms_choose_voice <- function(api_key = NULL,
                            gender = c("Female", "Male"),
                            language =  "en-US",
                            region = "westus") {
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

