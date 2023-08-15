#' Ensure UTF-8 Encoding of Character Columns
#'
#' @param x a tibble.
#' @param from encoding to convert from. Default is "latin1".
#' @param to encoding to convert to. Default is "UTF-8".
#'
#' @return a tibble where every character column is converted to "to" (i.e. "UTF-8").
#' @export
#'
#' @examples
#' ensure_utf8(x)
#'
ensure_utf8 <- function(x, from = "latin1", to = "UTF-8"){
  stopifnot("x must be a tibble" = is_tibble(x))
  x %>% mutate(
    across(
      .cols = where(is.character),
      .fns = ~ iconv(x = .x, from = from, to = to)
    )
  )
}

