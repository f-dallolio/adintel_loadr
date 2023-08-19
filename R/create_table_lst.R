#' Create list for CREATE TABLE
#'
#' @export
#'
create_table_lst <- function(table,
                              columns = list(column_name = NULL, data_type = NULL, precision = NULL),
                              unique = NULL,
                              partition_by_range = NULL){
  list(
    table = table,
    columns = list(column_name = column_name,
                   data_type = data_type,
                   precision = precision),
    unique = unique,
    partition_by_range = list(col, lower, upper)
  )
}

