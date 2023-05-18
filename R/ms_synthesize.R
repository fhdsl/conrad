#' Convert Text to Speech by using Speech Synthesis Markup Language (SSML)
ms_synthesize = function(script,
                         api_key = NULL,
                         token = NULL,
                         gender = c("Female", "Male"),
                         language = "en-US",
                         voice = NULL,
                         output_format = c("raw-16khz-16bit-mono-pcm", "raw-8khz-8bit-mono-mulaw",
                                           "riff-8khz-8bit-mono-alaw", "riff-8khz-8bit-mono-mulaw",
                                           "riff-16khz-16bit-mono-pcm", "audio-16khz-128kbitrate-mono-mp3",
                                           "audio-16khz-64kbitrate-mono-mp3", "audio-16khz-32kbitrate-mono-mp3",
                                           "raw-24khz-16bit-mono-pcm", "riff-24khz-16bit-mono-pcm",
                                           "audio-24khz-160kbitrate-mono-mp3", "audio-24khz-96kbitrate-mono-mp3",
                                           "audio-24khz-48kbitrate-mono-mp3"),
                         escape = FALSE,
                         region = NULL,
                         ...) {
  region <- ms_region(region)
  output_format <- match.arg(output_format)
  gender <- match.arg(gender)

  if (!is.null(voice)) {
    res <- ms_use_voice(voice = voice,
                        token = token,
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
  resp <- req %>% httr2::req_perform()

  # # Transfer binary data to WAV file
  # output <- tempfile(fileext = ".wav")
  # writeBin(resp$body, con = output)
  #
  # class(token) = "token"
  #
  # L = list(
  #   request = res,
  #   ssml = ssml,
  #   content = out,
  #   token = token,
  #   output_format = output_format
  # )
  # return(L)
}


#' Create Text To Speech Endpoint
#' @rdname ms_synthesize
#' @export
ms_tts_url = function(region = "westus") {
  region = ms_region(region)
  synth_url <- paste0("https://", region,
                      ".tts.speech.microsoft.com/",
                      "cognitiveservices/v1")
  synth_url
}

