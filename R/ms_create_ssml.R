#' Create Speech Synthesis Markup Language (SSML)
#'
#' @param script A character vector of lines to be spoken
#' @param voice Full voice name,
#' @param gender Sex of the Speaker
#' @param language Language to be spoken,
#' must be from \code{\link{ms_language_codes}}
#' @param escape Should non-standard characters be substituted?  Should not
#' be used if \code{script} has SSML tags
#' @return A character string of the text and SSML markup
#' @export
#'
#' @examples
#' ms_create_ssml("hey I really like things & dogs", escape = TRUE)
#' ms_create_ssml("hey I really like things")
#' ms_create_ssml('hey I <emphasis level="strong">really like</emphasis> things')
#' ms_create_ssml('hey I <emphasis level="strong">really like</emphasis> things',
#' escape = TRUE)
#'
ms_create_ssml = function(script,
                          voice = NULL,
                          gender = c("Female", "Male"),
                          language = "en-US",
                          escape = FALSE) {
  # Remove any HTML or XML tags
  if (escape) {
    script = gsub("[<>/]", "", script)
    script = gsub("&", "and", script)
  }
  stopifnot(length(language) == 1)
  gender = match.arg(gender)
  stopifnot(length(gender) == 1)

  # Create SSML
  ssml <- c(paste0("<speak version='1.0' ", "xml:lang='", language, "'>"),
            paste0("<voice xml:lang='", language ,"'", " xml:gender='", gender, "'"),
            paste0(" name='", voice, "'"), ">",
            script, "</voice>", "</speak>")
  ssml <- paste(ssml, collapse = "")

  ssml
}
