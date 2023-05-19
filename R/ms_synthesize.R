#' Convert Text to Speech by using Speech Synthesis Markup Language (SSML)
#'
#' @param script A character vector of text to be converted to speech
#' @param region Subscription region for API key. For more info, see
#' \url{https://learn.microsoft.com/en-us/azure/cognitive-services/speech-service/regions}
#' @param api_key Microsoft Azure Cognitive Services API key
#' @param token An authentication token
#' @param gender Sex of the speaker
#' @param language Language to be spoken
#' @param voice Full voice name
#' @param escape Should non-standard characters be substituted?
#'
#' @return A response in binary format
#' @export
ms_synthesize = function(script,
                         region = "westus",
                         api_key = NULL,
                         token = NULL,
                         gender = c("Female", "Male"),
                         language = "en-US",
                         voice = NULL,
                         escape = FALSE) {
  region <- ms_region(region)
  gender <- match.arg(gender)

  if (!is.null(voice)) {
    res <- ms_use_voice(voice = voice,
                        api_key = api_key,
                        region = region)
  } else {
    res <- ms_choose_voice(region = region,
                           language = language,
                           gender = gender)
  }
  language <- res$language
  gender <- res$gender
  voice <- res$full_name
  tts_url <- ms_tts_url(region = region)

  if (is.null(token)) {
    token <- ms_get_token(api_key = api_key,
                          region = region)$token
  }
  # Create Speech Synthesis Markup Language (SSML)
  ssml <- ms_create_ssml(script = script,
                         gender = gender,
                         language = language,
                         voice = voice,
                         escape = escape)

  # Create a request
  req <- httr2::request(tts_url)
  # Specify HTTP headers
  req <- req %>%
    httr2::req_headers(`Content-Type` = "application/ssml+xml",
                       `X-Microsoft-OutputFormat` = "riff-24khz-16bit-mono-pcm",
                       `Authorization` = paste("Bearer",  as.character(token)),
                       `User-Agent` = "MyTextToSpeechApp",
                       `Host` = paste0(region, ".", "tts.speech.microsoft.com")) %>%
    httr2::req_body_raw(ssml)
  # Perform a request and fetch the response
  resp <- req %>%
    httr2::req_perform()
  # Binary response
  out <- resp$body

  out
}

#' Create Text To Speech Endpoint
#' @rdname ms_synthesize
#' @export
ms_tts_url = function(region = "westus") {
  region = ms_region(region)
  tts_url <- paste0("https://", region,
                    ".tts.speech.microsoft.com/",
                    "cognitiveservices/v1")
  tts_url
}

