#' Find API Key for Microsoft Cognitive Services Text To Speech (TTS)
#'
#' Determines if \code{option(ms_tts_key)} is set or key is stored in an
#' environment variable (MS_TTS_API_KEY, MS_TTS_API_KEY1, MS_TTS_API_KEY2). If
#' not found, stops and returns an error. If found, returns the value.
#'
#' @param api_key Microsoft Cognitive Services API key
#' @param error Should the function error if \code{api_key = NULL}?
#' @param region Subscription region for API key. For more info, see
#'   \url{https://learn.microsoft.com/en-us/azure/cognitive-services/speech-service/regions}
#'
#' @note You can either set the API key using \code{option(ms_tts_key)} or have
#'   it accessible by \code{api_key = Sys.getenv('MS_TTS_API_KEY")}, or
#'   \code{api_key = Sys.getenv('MS_TTS_API_KEY1")}, or \code{api_key =
#'   Sys.getenv('MS_TTS_API_KEY2")}
#'
#' @return API key
#' @export
#' @examplesIf interactive()
#' res = ms_fetch_key(api_key = NULL, error = FALSE)
ms_fetch_key <- function(api_key = NULL, error = TRUE) {
  # Global Option
  if (is.null(api_key)) {
    api_key = getOption("ms_tts_key")
  }
  # Environment
  key_env_names = c("MS_TTS_API_KEY", "MS_TTS_API_KEY1", "MS_TTS_API_KEY2")
  for (ii in key_env_names) {
    if (is.null(api_key)) {
      api_key = get_env_key(ii)
    }
  }
  # Empty key
  if (!is.null(api_key)) {
    if (api_key %in% "") {
      api_key = NULL
    }
  }
  # Error message
  if (is.null(api_key) & error) {
    stop(paste0("Microsoft Cognitive Services Text To Speech (TTS) API Key not found ",
                "please set option('ms_tts_key') for general use or ",
                "set environment variable MS_TTS_API_KEY, to be ",
                "accessed by Sys.getenv('MS_TTS_API_KEY')"))
  }

  api_key
}

#' @describeIn ms_fetch_key Does user have API key?
#' @return Logical vector, indicating whether user has API key.
#' @export
#'
#' @examplesIf interactive()
#' # Don't provide api key but fetch it programmatically
#' ms_exist_key(api_key = NULL)
#'
#' # Provide api key XXX
#' ms_exist_key(api_key = "XXX")
ms_exist_key <- function(api_key = NULL) {
  api_key <- ms_fetch_key(api_key = api_key, error = FALSE)
  !is.null(api_key)
}


#' @describeIn ms_fetch_key Set API Key as a global option
#' @return NULL
#' @export
#'
#' @examplesIf interactive()
#' # Set api key XXX
#' ms_set_key(api_key = "XXX")
ms_set_key <- function(api_key) {
  options("ms_tts_key" = api_key)
  invisible(NULL)
}


#' @describeIn ms_fetch_key Check whether API key is valid
#' @return Logical vector, indicating whether API key is valid.
#' @export
#' @examplesIf interactive()
#' # Check whether API key is valid in westus
#' ms_valid_key(region = "westus")
ms_valid_key <- function(api_key = NULL, region = "westus") {
  res <- try({
    ms_get_token(api_key = api_key,
                 region = region)
    })
  if (inherits(res, "try-error")) {
    return(FALSE)
  }
  resp <- res$response

  httr2::resp_status(resp) < 400
}

#' Get Microsoft Text To Speech (TTS) or Cognitive Services Token from API Key
#'
#' @param api_key Microsoft Azure Cognitive Services API key
#' @param region Subscription region for API key. For more info, see
#'   \url{https://learn.microsoft.com/en-us/azure/cognitive-services/speech-service/regions}
#' @return A list of the request and token
#' @export
#'
#' @examplesIf ms_valid_key()
#' # Get token where region is westus
#' token = ms_get_token(region = "westus")
ms_get_token <- function(api_key = NULL,
                        region = "westus") {
  # Setup URL and API Key
  token_url <- ms_token_url(region = region)
  api_key <- ms_fetch_key(api_key = api_key, error = TRUE)

  # Create a request
  req <- httr2::request(token_url)
  # Specify HTTP headers
  req <- req %>%
    httr2::req_headers(
      `Ocp-Apim-Subscription-Key` = api_key,
      `Host` = paste0(region, ".", "api.cognitive.microsoft.com"),
      `Content-Type` = "application/x-www-form-urlencoded",
      `Content-Length` = 0) %>%
    httr2::req_body_raw("")

  # Perform a request and fetch the response
  resp <- req %>%
    httr2::req_perform()

  # Extract token in JSON Web Token (JWT) format as raw bytes
  resp_raw <- httr2::resp_body_raw(resp)
  # Convert to character string
  base64_token <- rawToChar(resp_raw)
  # Add timestamp
  attr(base64_token, "timestamp") <- Sys.time()
  # Token class
  class(base64_token) <- "token"

  list(request = req,
       response = resp,
       token = base64_token)
}


# Create issueToken URL Endpoint to get access token
ms_token_url <- function(region = conrad::region) {
  if (!is.null(region)) {
    region = match.arg(region)
  } else {
    region = getOption("ms_region")
  }
  if (!is.null(region)) {
    region = paste0(region, ".")
  }

  token_url = paste0("https://", region,
                     "api.cognitive.microsoft.com/sts/v1.0/issueToken")
  return(token_url)
}


#' Check if token has expired

#' @param token An authentication of class \code{token},
#' likely from \code{\link{ms_get_token}}
#'
#' @rdname ms_get_token
#' @return Logical vector, indicating whether token has expired
#' @export
#'
#' @examplesIf interactive()
#' # Check if token XXX has expired
#' ms_token_expired(token = "XXX")
ms_token_expired <- function(token = NULL) {
  if (!inherits(token, "token")) {
    if (is.list(token)) {
      token <- token$token
    }
  }
  token_timestamp <- attr(token, "timestamp")
  if (is.null(token_timestamp)) {
    warning("Timestamp unknown for the token! Please refresh")
    return(TRUE)
  }

  d <- difftime(Sys.time(), token_timestamp, "mins")
  return(d >= 10)
}
