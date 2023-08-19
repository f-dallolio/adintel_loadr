#' Create Table components
#'
#' @export
#'
sql_column_defition <- function(column_name, data_type, precision){
  ok_name <- glue("{column_name}")
  if(!is.na(precision)){
    out <- glue(" \t \t {ok_name} \t \t {data_type}({precision})")
    print(out)
    return()
  }
  out <- glue(" \t \t {ok_name} \t \t {data_type}")
  print(out)
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
