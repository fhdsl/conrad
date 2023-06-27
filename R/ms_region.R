#' Check if provided region is supported by Speech service
#'
#' If region is supported, this function returns the region. If not supported, throws a warning message.
#'
#' @param region Subscription region for API key. For more info, see
#' \url{https://learn.microsoft.com/en-us/azure/cognitive-services/speech-service/regions}
#'
#' @return region
#' @export
#'
#' @examplesIf interactive()
#' # Check if westus is supported
#' ms_region(region = "westus")
#' # Check if eastus is supported
#' ms_region(region = "eastus")
ms_region = function(region = conrad::region) {
  if (missing(region)) {
    region = getOption("ms_region")
  }
  if (any(!(region %in% conrad::region))) {
    warning("Region(s) not supported by Speech service")
    stopifnot(length(region) >= 1)
    region = region[1]
  } else {
    region = match.arg(region)
  }

  region
}

# Set region
ms_set_region = function(region = conrad::region) {
  region = match.arg(region)
  options(ms_region = region)
  return(region)
}

