#' Load Adintel Tsv file
#'
#' @param file string.
#' @param col_names character vector.
#' @param col_types cols() definition
#'
#' @return a tibble.
#' @export
#'
read_adintel_tsv <- function(file, col_names, col_types){
  read_tsv(
    file = file,
    col_names = col_names,
    col_types = col_types,
    skip_empty_rows = TRUE,
    skip = 1
  ) %>%
    ensure_utf8()
}
