#' Title
#'
#' @param x a tibble
#' @param from encoding to convert from. Default is "latin1"
#' @param to encoding to convert to. Default is "UTF-8"
#'
#' @return a tibble where every character column is converted to "to" (e.g. "UTF-8")
#' @export
#'
#' @examples
ensure_utf8 <- function(x, from = "latin1", to = "UTF-8"){
  stopifnot("x must be a tibble" = tibble::is_tibble(x))
  dplyr::mutate(
    .data = x,
    dplyr::across(
      .cols = tidyselect::where(is.character),
      .fns = ~ iconv(x = x, from = from, to = to)
    )
  )
}
