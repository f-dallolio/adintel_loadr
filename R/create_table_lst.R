#' Create list for CREATE TABLE
#'
#' @export
#'
create_table_maker <- function(table,
                             column_name,
                             data_type,
                             precision = NULL,
                             unique = NULL,
                             .col_partitionn =  NULL){
  list(
    table = table,
    columns = list(column_name = column_name,
                   data_type = data_type,
                   precision = precision),
    unique = unique,
    .col_partitionn = .col_partitionn
  )
}
