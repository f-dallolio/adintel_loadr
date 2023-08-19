#'  Padding of strings
#'
#' @export
#'
#' @examples
#' stopifnot("pad must be string" = is.character(pad))
#'
str_charpad <- function(x, pad = "", off_margin = 0) {
  stopifnot("pad must be string" = is.character(pad))
  stopifnot("off_margin must be positive" = off_margin > 0)
  x <- as.character(x)
  width <- max(nchar(x)) + off_margin
  # max_nchar <- max(nchar(x))
  # if(is.null(width)){width <- max_nchar}
  # stopifnot("width must be >= max(nchar(x))", width < max_nchar)

  stringr::str_pad(
    string = x,
    width = width,
    side = "right",
    pad = pad
  )
}
