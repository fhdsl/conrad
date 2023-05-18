#' Get Full List of Voices for Specified Region
#'
#' @param api_key Microsoft Cognitive Services API key
#' @param region Subscription region for your key.
#' @param token An authentication token
#' See \url{https://docs.microsoft.com/en-us/azure/cognitive-services/speech-service/overview}
#' @param ... Additional arguments to send to \code{\link{GET}}
#' @return A \code{data.frame} of the names and their long names.
#' @export
ms_list_voice = function(api_key = NULL,
                         region = NULL,
                         ...) {
  region <- ms_region(region)
  list_voice_url <- paste0("https://", region,
                     ".tts.speech.microsoft.com/",
                     "cognitiveservices/voices/list")
  if (is.null(api_key)) {
    api_key <- ms_fetch_key(api_key = api_key)
  }

  # Create a request
  req <- httr2::request(list_voice_url)
  # Specify HTTP headers
  req <- req %>%
    httr2::req_headers(
      `Host` = paste0(region, ".", "api.cognitive.microsoft.com"),
      `Ocp-Apim-Subscription-Key` = api_key)

  # Perform a request and fetch the response
  resp <- req %>%
    httr2::req_perform()

  # Extract JSON
  out <- httr2::resp_body_string(resp)
  # Convert JSON to a single, non-nested data frame
  out <- jsonlite::fromJSON(out, flatten = TRUE)

  out
}
