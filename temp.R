devtools::install_github("f-dallolio/fdutils")
devtools::install_github("f-dallolio/adloadr")
library(tidyverse)
library(glue)
library(DBI)
library(RPostgres)
library(fdutils)
library(adloadr)

pswd <- "100%Postgres"
extract_dir <- "/media/filippo/One Touch/nielsen_data/adintel/"
archive_name <- "ADINTEL_DATA_{year}/"


year <- 2014
con <- connect_db_general(year = year, password = pswd)
db_tbls <- DBI::dbListTables(con)



tbl_occurrences <- loader_tbl_occurrences %>%
  rename(table_names = tablename) %>%
  select(- filetype)


list_occurrences <- map(seq_along(tbl_occurrences$file),
                        ~ list(file = tbl_occurrences$file[[.x]],
                               col_names = tbl_occurrences$col_names[[.x]],
                               col_types = tbl_occurrences$col_types[[.x]],
                               table_names = tbl_occurrences$table_names[[.x]]))


write_db_table <- function(
  year,
  con,
  file_name,
  col_names,
  col_types,
  table_name,
  archive_dir = "/media/filippo/One Touch/nielsen_data/adintel",
  archive_name = "ADINTEL_DATA_{year}",
  occurrence_dir = "nielsen_extracts/AdIntel/{year}/Occurrences"
){
  file <- glue(str_c(archive_dir, archive_name, occurrence_dir, file_name, sep = "/"))
  tbl_out <- read_adintel_tsv(file = file, col_names = col_names, col_types = col_types)
  DBI::dbWriteTable(conn = con, name = table_name, value = tbl_out)
}

i =1







base::intersect(names)




list_occurrences[[1]]

list(file,
     col_names,
     col_types)

i=1
for(i in seq_along(list_occurrences)){

  list_i <- list_occurrences[[i]]

  x <- read_adintel_tsv(file = list_i$file, col_names = list_i$col_names, col_types = list_i$col_types)


}



years <- 2019:2021
seq_id <- seq_along(years)
for(i in seq_id){

}






year
map, ~ x %>% mutate(file = glue(file)))

xxx$full_dir %>% glue() %>% list.files()

xxx %>% nest(.by = full_dir)

x1 <- list.files("/media/filippo/One Touch/nielsen_data/adintel/", full.names = T, recursive = T) %>%
  str_subset("Occurrences") %>%
  as_tibble_col(column_name = "file") %>%
  mutate(file_name = file %>% str_split_i("/", -1)) %>%
  left_join(xxx %>% select(- full_dir), by = c("file_name" = "file")) %>%
  select(-file_name) %>%
  slice(1)

read_adintel_tsv(x1


tbl_list <- DBI::dbListTables(con)

x1 <- xxx %>%
  mutate(file = file %>% map(~ glue(.x)) %>% unlist())

xread <- function(file, col_names, col_types){
  tbl_out <- read_adintel_tsv()
    file = file,
    col_names = col_names,
    col_types = col_types
  )
}

x1
read_tsv(file = "/media/filippo/One Touch/nielsen_data/adintel/ADINTEL_DATA_2010/nielsen_extracts/AdIntel/2010/Occurrences/FSICoupon.tsv")

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
