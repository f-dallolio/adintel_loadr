#' Create a DB connection (RPostgres)
#'
#' @return a connection.
#' @export
#'
connect_db <- function() {

  # host  <-  rstudioapi::showPrompt(title = "host", message = 'Server name/ip')
  host  <-  '10.147.18.200'
  dbname <-  rstudioapi::showPrompt(title = "dbname", message = 'Name of the database (e.g. adintel_2014)')
  # user  <-  rstudioapi::showPrompt(title = "user", message = 'Username')
  user  <-  'postgres'
  password <-  rstudioapi::askForPassword("Password")

  DBI::dbConnect(
    RPostgres::Postgres(),
    dbname = dbname,
    host = host,
    port = 5432,
    user = user,
    password = password
  )
}
