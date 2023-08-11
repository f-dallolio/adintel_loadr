load("R/sysdata.rda")

library(magrittr)



year <- 2010
dir_extract <- "/media/filippo/One Touch/nielsen_data/adintel/"
archive_name <- "ADINTEL_DATA_{year}"
connection <- DBI::dbConnect(RSQLite::SQLite(), dbname = ":memory:")


purrr::map(loader_list, ~ .x $ table)



DBI::dbListTables(conn)


db_populate_i <- function(names_list, year, dir_extract, archive_name, connection){

  names_list <- loader_list

  arch_name <- glue::glue(archive_name)
  dir_name <- glue::glue(names_list$dir)
  table_name <- names_list$table
  file_name <- names_list$file
  file <- paste0(c(dir_extract, arch_name, dir_name, file_name), collapse = "/")

  col_names <- names_list$col_names
  col_types <- names_list$col_types

  tbl_out <- readr::read_tsv(
    file = file,
    col_names = col_names,
    col_types = col_types,
    skip_empty_rows = TRUE,
    skip = 1
  )



  DBI::dbWriteTable(
    conn = conn,
    name = table_name,
    value = tbl_out
  )

}


db_populate_i(loader_list = loader_list[[1]],
              year = 2010,
              dir_extract =  "/media/filippo/One Touch/nielsen_data/adintel",
              archive_name = "ADINTEL_DATA_{year}",
              connection = connection)





digital_check <- list.files(
  str_c(dir_extract, archive_name),
  recursive = T) %>%
  str_detect("Digital.tsv") %>%
  any()

digital_check

if(!digital_check){
  loader_tbl %>% filter(str_detect(tablename, "digital", negate = TRUE))
}


DBI::dbDisconnect(connection)
