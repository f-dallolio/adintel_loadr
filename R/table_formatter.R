#' Remove Schema Name from dbcooper Functions
#'
#' @param string a string or a character vector.
#' @param schema_name a string.
#'
#' @return a string or a character vector.
#' @export
#'
#' @examples
#' x <- c("public.table1", "table2")
#' table_formatter(x)
table_formatter <- function(x, schema_name = "public") {
  stringr::str_remove_all(string = x, pattern = paste0(schema_name, "."))
}
