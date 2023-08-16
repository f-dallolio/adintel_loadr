#' Utility functions to modify AdIntel Occurrences data
#'
#' @param con a connection.
#' @param new_table a string.
#' @param old_table a string.
#' @param media_type_id a number.
#'
#' @export
#'
split_occurrence_query <- function(con, new_table, old_table, media_type_id){
  statement <- glue(
    "CREATE TABLE IF NOT EXISTS {new_table} AS SELECT * FROM {old_table} WHERE media_type_id = {media_type_id}"
  )
  # print(statement)
  DBI::dbSendQuery(conn = con, statement = statement)
  print(
    glue('Done with ({new_table}) from ({old_table})')
  )
}

#' @param table_name a string.
#'
#' @export
#'
drop_old_table_query <- function(con, table_name){
  statement <- glue('DROP TABLE IF EXISTS {table}')
  # print(statement)
  DBI::dbSendQuery(conn = con, statement = statement)
}

#' @param x a tibble with the following columns: c('old_table', 'new_table', 'media_type_id').
#'
#' @export
#'
drop_old_table_i <- function(con, x){
  seq_id <- seq_along(row_number(x))
  old_table <- unique(x$old_table)
  for(i in seq_id){
    new_table <- x$new_table[[i]]
    media_type_id <- x$media_type_id[[i]]
    split_occurrence_query(con = con,
                           new_table = new_table,
                           old_table = old_table,
                           media_type_id = media_type_id)
  }
  drop_old_table_query(con = con, table_name = old_table)
}

#' @param old_table_column unquoted name of the column in x that contains the names of the old tables.
#'
#' @export
#'
split_occurrence_table <- function(con, x, old_table_column){
  id_names <- x %>% distinct({{old_table_column}}) %>% pull
  id_list <- map(.x = id_names, .f = ~ filter(x, {{old_table_column}} == .x)) %>% set_names(id_names)
  id_list
}

#' @param table_list a list of tibbles  with the following columns: c('old_table', 'new_table', 'media_type_id').
#'
#' @export
#'
drop_old_table <- function(con, table_list){
  walk(table_list, ~ drop_old_table_i(con, .x))
}

#' @param years a vector of numbers indicating the years of interest.
#' @param password prompot to type db password.
#'
#' @export
#'
drop_old_table_allyears <- function(years, password = rstudioapi::askForPassword()){
  for(year in years){
    print(glue('Year {year}'))
    con <- connect_db_general(year = year, password = password)
    tbl_list <- DBI::dbListTables(con)
    media_tbl <- media_layout %>% select(old_table, new_table, media_type_id) %>%
      filter(old_table %in% tbl_list)
    table_list <- split_occurrence_table(con = con, x = media_tbl, old_table_column = old_table)
    drop_old_table(con = con, table_list = table_list)
    DBI::dbDisconnect(con)
  }
}
