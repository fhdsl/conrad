#' Get List of Voices for Specified Region
#'
#' Obtains a full list of voices for a specific region.
#'
#' For more info, see [Get a list of voices](https://learn.microsoft.com/en-us/azure/cognitive-services/Speech-Service/rest-text-to-speech?tabs=streaming#get-a-list-of-voices)
#' from the Microsoft documentation.
#'
#' @param api_key Microsoft Azure Cognitive Services API key
#' @param region Subscription region for API key. For more info, see
#' \url{https://learn.microsoft.com/en-us/azure/cognitive-services/speech-service/regions}
#' @return A \code{data.frame} of the names and their long names.
#' @export
#'
#' @examplesIf interactive()
#' # List voices for westus
#' ms_list_voice(region = "westus")
#'
#' # List voices for eastus
#' ms_list_voice(region = "eastus")
ms_list_voice = function(api_key = NULL,
                         region = "westus") {
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
