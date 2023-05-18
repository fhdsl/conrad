get_env_key = function(x) {
  x = Sys.getenv(x)
  if (is.null(x)) {
    return(x)
  }
  if (x == "") {
    return(NULL)
  }
  return(x)
}

#' Play audio in a browser
#'
#' This uses HTML5 audio tags to play audio in your browser. Borrowed from \code{googleLanguageR::gl_talk_player()}
#'
#' @param audio The file location of the audio file.  Must be supported by HTML5
#' @param html The html file location that will be created host the audio
#'
#' @export
#' @importFrom utils browseURL
play_audio <- function(audio = "output.wav",
                       html = "player.html"){
  # Write html code to a html file
  writeLines(sprintf('<html><body>
    <audio controls autoplay>
                     <source src="%s">
                     </audio>
                     </body></html>',
                     audio),
             html)
  # Load URL into browser
  utils::browseURL(html)
}
