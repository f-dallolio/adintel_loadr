
devtools::install_github("f-dallolio/adloadr")
library(tidyverse)
library(glue)
library(DBI)
library(RPostgres)
library(adloadr)

year <- 2010
dir_extract <- "/media/filippo/One Touch/nielsen_data/adintel/"
archive_name <- "ADINTEL_DATA_{year}"
connection <- DBI::dbConnect(
  RPostgres::Postgres(),
  dbname = "adintel",
  host = "10.147.18.200",
  user = "postgres",
  password = "100%Postgres"
)

i=1
loader_tbl

db_table_i <- function(names_list, year, dir_extract, archive_name, connection){

  arch_name <- glue(archive_name)
  dir_name <- glue(names_list$dir)
  table_name <- names_list$table
  file_name <- names_list$file
  file <- paste0(c(dir_extract, arch_name, dir_name, file_name), collapse = "/")

  col_names <- names_list$col_names[[1]]
  col_types <- names_list$col_types[[1]]

  tbl_out <- read_adintel_tsv(
    file = file,
    col_names = col_names,
    col_types = col_types
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
