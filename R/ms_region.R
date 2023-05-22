#' Check if provided region is supported by Speech service
#'
#' @param region Subscription region for API key. For more info, see
#' \url{https://learn.microsoft.com/en-us/azure/cognitive-services/speech-service/regions}
#'
#' @return region
#' @export
ms_region = function(region = mscstts2::region) {
  if (missing(region)) {
    region = getOption("ms_region")
  }
  if (any(!(region %in% mscstts2::region))) {
    warning("Some regions not supported by Speech service")
    stopifnot(length(region) >= 1)
    region = region[1]
  } else {
    region = match.arg(region)
  }

  region
}

#' @rdname ms_region
#' @export
ms_set_region = function(region = mscstts2::region) {
  region = match.arg(region)
  options(ms_region = region)
  return(region)
}

