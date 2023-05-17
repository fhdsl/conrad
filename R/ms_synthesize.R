#' Convert Text to Speech by using Speech Synthesis Markup Language (SSML)
ms_synthesize = function(script,
                         token = NULL,
                         api_key = NULL,
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
                         api = c("tts", "bing"),
                         ...) {
  region = ms_region(region)
  output_format = match.arg(output_format)
  gender <- match.arg(gender)

  if (!is.null(voice)) {
    L = ms_voice_info(voice,
                      token = token,
                      api_key = api_key,
                      region = region)
  } else {
    L = ms_validate_language_gender(
      language = language,
      gender = gender)
  }
  language = L$language
  gender = L$gender
  voice = L$full_name[1]

  synth_url = ms_synthesize_api_url(
    api = api,
    region = region
  )

  if (is.null(token)) {
    token = ms_get_tts_token(api_key = api_key,
                             region = region)$token
  }
  # Create Speech Synthesis Markup Language (SSML)
  ssml <- ms_create_ssml(script = script,
                         gender = gender,
                         language = language,
                         voice = voice,
                         escape = escape)
  ssml <- "<speak version='1.0' xml:lang='en-US'><voice xml:lang='en-US' xml:gender='Male' name='Microsoft Server Speech Text to Speech Voice (en-US, GuyNeural)'>Microsoft Speech Service Text-to-Speech API</voice></speak>"

  # Create a request
  req <- httr2::request(synth_url)

  # Specify HTTP headers
  req <- req %>%
    httr2::req_headers(`Content-Type` = "application/ssml+xml",
                       `X-Microsoft-OutputFormat` = "riff-24khz-16bit-mono-pcm",
                       `Authorization` = paste("Bearer",  as.character(token)),
                       `User-Agent` = "MyTextToSpeechApp",
                       `Host` = paste0(region, ".", "tts.speech.microsoft.com")) %>%
    httr2::req_body_raw(ssml)

  # Perform a request and fetch the response
  req %>% httr2::req_perform()

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



#' Read Synthesized output
#'
#' @param output List from \code{\link{ms_synthesize}} with elements
#' \code{output_format} and \code{content}
#'
#' @note The \code{tuneR} package cannot read all different types of
#' the output here.
#'
#' @return A Wave Object
#' @export
ms_read_synthesis = function(output) {
  tmp = tempfile()
  writeBin(output$content, con = tmp)
  output_format = output$output_format
  wav = grepl("riff", tolower(output_format))
  mp3 = grepl("mp3", tolower(output_format))
  if (!wav & !mp3) {
    warning("No format determined, assuming it's a WAV")
    wav = TRUE
  }

  if (wav) {
    out = tuneR::readWave(tmp)
  }
  if (mp3) {
    out = tuneR::readMP3(tmp)
  }
  return(out)
}



#' Create URL Endpoint that allows you to convert text to speech
#' @rdname ms_synthesize
#' @param api Chose API to authorize on (\code{tts} for text to speech or
#'   \code{bing} for Bing text to speech API)
#' @export
ms_synthesize_api_url = function(
    api = c("tts", "bing"),
    region = NULL
){
  api = match.arg(api)

  region = ms_region(region)
  synth_url = switch(
    api,
    bing = paste0(
      'https://speech.platform.bing.com/',
      'synthesize'),
    tts = paste0("https://", region,
                 ".tts.speech.microsoft.com/",
                 "cognitiveservices/v1")
  )
  return(synth_url)
}

