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
  return(region)
}

#' @rdname ms_synthesize
#' @export
ms_set_region = function(
    region = mscstts2::region) {
  region = match.arg(region)
  options(ms_region = region)
  return(region)
}

