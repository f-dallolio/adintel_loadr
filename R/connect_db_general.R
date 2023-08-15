#' Create a DB connection to AdIntel (RPostgres)
#'
#' @param year a number.
#' @param host a string.
#' @param user a stringr.
#' @param password a string.
#'
#' @export
#'
connect_db_general <- function(year, host ='10.147.18.200',  user = "postgres", password ) {

  dbname <- paste0('adintel_', year)

  DBI::dbConnect(
    RPostgres::Postgres(),
    dbname = dbname,
    host = host,
    port = 5432,
    user = user,
    password = password
  )
}
