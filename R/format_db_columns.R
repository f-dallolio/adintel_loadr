format_db_columns <- function(years, password){
  for(year in years){

    con <- connect_db_general(year = year, password = password)

    env <- .GlobalEnv
    # env <- parent.env(environment())
    dbcooper::dbc_init(con = con,
                       con_id = "adintel",
                       env = env,
                       table_formatter = table_formatter)
    tbl_list <- adintel_list() %>% table_formatter()

    new_tbl_names <- purrr::map(
      .x = tbl_list,
      .f = ~ tibble::tibble(
        table = .x,
        old_names = DBI::dbListFields(conn = con, name = .x)
      )) %>%
      purrr::list_rbind() %>%
      dplyr::mutate(
        new_names = old_names %>%
          fdutils::str_upper_split(exceptions = exceptions)
      ) %>%
      dplyr::filter(old_names != new_names)

    seq_id <- seq_along(new_tbl_names$table)

    i=1
    for(i in seq_id){
      table <- new_tbl_names$table[[i]]
      old_name <- new_tbl_names$old_names[[i]]
      new_name <- new_tbl_names$new_names[[i]]
      query <- glue::glue('ALTER TABLE {table} RENAME COLUMN "{old_name}" TO {new_name}')
      adintel_execute(query = query)
      cat(c(i, table, old_name, new_name))
    }
  }
}
