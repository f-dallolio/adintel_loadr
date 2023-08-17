#' Send SQL DROP TABLE
#'
#' @param con a connection.
#' @param table_name a string.
#'
#' @export
#'
send_drop_table <- function(con, table_name){
  statement <- glue('DROP TABLE IF EXISTS {table_name}')
  print(statement)
  DBI::dbSendQuery(conn = con, statement = statement)
}
