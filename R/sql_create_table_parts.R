#' Create Table components
#'
#' @export
#'
sql_column_defition <- function(column_name, data_type, precision){
  quo_name <- glue('"{column_name}"')
  if(is.na(precision)){
    out <- glue::glue('  {str_charpad(x = quo_name, pad = " ", off_margin = 2)} {data_type}')
    return(out)
  }
  glue::glue('  {str_charpad(x = quo_name, pad = " ", off_margin = 2)} {data_type}({precision})')
}
#'
#' @export
#'
sql_create_table_cols <- function(.tbl){
  stopifnot('.tbl must be a a tibble or a list with names: "column_name", "data_type", "precision"' =
              names(.tbl) %in% c("name", "type", "precision"))
  purrr::pmap(.l = .tbl, .f = sql_column_defition) %>%
    paste(collapse = ", \n") %>%
    glue::glue()
}
