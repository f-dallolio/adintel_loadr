#' Transform String from AbcDe to abc_de
#'
#' @param string a string or a character vector.
#' @param sep a string used as separator. Default is '_'.
#' @param to_lower logical. Default is TRUE and mutate 'string' to lower case.
#'
#' @return
#' @export
#'
#' @examples
#' x <- "AbcdEfgHi"
#' str_separate_AbCd(x)
str_separate_AbCd <- function(string, sep = '_', to_lower = TRUE){
  out <- gsub(pattern = "([[:upper:]])", replacement = " \\1", x = string) %>%
    str_squish() %>%
    str_replace_all(pattern = " ", replacement = sep)
  if (to_lower) {
    out <- tolower(out)
  }
  return(out)
}
