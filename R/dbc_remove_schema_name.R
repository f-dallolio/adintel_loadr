#' Remove Schema Name in Front of Table Names
#'
#' @param string string or character vector with table names.
#' @param schema_name string with name of schema.
#'
#' @return string or character vector with new table names.
#' @export
#'
#' @examples
#' x <- "public.table1"
#' dbc_remove_schema_name(x)
dbc_remove_schema_name <- function(string, schema_name = "public"){
  str_remove_all(string, str_c(schema_name, "."))
}
