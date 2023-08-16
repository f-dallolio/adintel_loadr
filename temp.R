
devtools::install_github("f-dallolio/adloadr")
library(tidyverse)
library(glue)
library(DBI)
library(RPostgres)
library(fdutils)
library(adloadr)

year <- 2014
dir_extract <- "/media/filippo/One Touch/nielsen_data/adintel/"
archive_name <- "ADINTEL_DATA_{year}"
connection <- DBI::dbConnect(
  RPostgres::Postgres(),
  dbname = "adintel_2014",
  host = "10.147.18.200",
  user = "postgres",
  password = "100%Postgres"
)

i=1
names_list <- loader_tbl %>% filter(tablename == "cinema")

db_table_i <- function(names_list, year, dir_extract, archive_name, connection){

  arch_name <- glue(archive_name)
  dir_name <- glue(names_list$dir)
  table_name <- names_list$tablename
  file_name <- names_list$file
  file <- paste0(c(dir_extract, arch_name, dir_name, file_name), collapse = "/")

  col_names <- names_list$col_names[[1]]
  col_types <- names_list$col_types[[1]]

  tbl_out <- read_adintel_tsv(
    file = file,
    col_names = col_names,
    col_types = col_types
  )

  names(tbl_out) <- names(tbl_out) %>% str_upper_split() %>% str_replace_all("i_d", "id")

  DBI::dbWriteTable(conn = connection, name = table_name, value = tbl_out)

}
DBI::dbDisconnect(connection)
