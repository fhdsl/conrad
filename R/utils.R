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
