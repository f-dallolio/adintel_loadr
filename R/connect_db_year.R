#' Create a DB connection to AdIntel by year (RPostgres)
#'
#' @param year a number.
#'
#' @return
#' @export
#'
connect_db_year <- function(year) {
  host  <-  '10.147.18.200'
  dbname <- paste0('adintel_', year)
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
