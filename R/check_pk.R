#' Checks Uniqueness of Primary Keys
#'
#' @export
#'
check_pk_i <- function(con, table, pk){
  print(glue::glue("\n\n Checking {table}"))
  dm_df <- dm::dm_from_con(con = con, table_names = table, learn_keys = T)
  dm_df <- dm_df %>%
    dm::dm_add_pk(table = !!table, columns = !!pk)
  print(glue::glue("---- Created data model"))
  pk_ok <- try(dm_df %>% dm::dm_examine_constraints())

  if(pk_ok$problem == ""){
    print(glue::glue("---- Examined constraints: No problem recorded"))
    tibble(table = table, pk_ok = "OK")
  } else {
    issue1 <- pk_ok$problem %>% str_split_i(": ", 1)
    print(glue::glue("---- Examined constraints: ISSUE ({issue1})"))
    tibble(table = table, pk_ok = pk_ok$problem)
  }
}
#
#' @export
#'
check_pk_list <- function(con, pk_list){
  db_tbls <- DBI::dbListTables(con)
  pk_list <- pk_list[names(pk_list) %in% db_tbls]
  seq_id <- seq_along(pk_list)
  for(i in seq_id){
    table_i <- names(pk_list)[[i]]
    pk_i <- pk_list[[i]]
    pk_out_i <- check_pk_i(con = con, table = table_i, pk = pk_i)
    if(i == seq_id[[1]]){
      pk_out <- pk_out_i
    } else {
      pk_out <- pk_out %>% bind_rows(pk_out_i)
    }
  }
  return(pk_out)
}
