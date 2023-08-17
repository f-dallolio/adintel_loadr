devtools::install_github("f-dallolio/fdutils")
devtools::install_github("f-dallolio/adloadr")
library(tidyverse)
library(glue)
library(DBI)
library(RPostgres)
library(fdutils)
library(adloadr)

tbl_occurrences <- loader_tbl_occurrences %>%
  select(- filetype) %>%
  rename(table_names = tablename)

year <- 2021
con <- connect_db_general(year = year, password = "100%Postgres")

db_files_0 <- list.files(
  "/media/filippo/One Touch/nielsen_data/adintel/",
  full.names = T,
  recursive = T
) %>%
  as_tibble_col("file_name") %>%
  filter(file_name %>% str_detect("Occurrences")) %>%
  filter(file_name %>% str_detect(glue("{year}"))) %>%
  mutate(file = file_name %>% str_split_i("/", -1)) %>%
  left_join(tbl_occurrences %>% select(-dir))


db_files <- db_files_0 %>%
  filter(table_names != "digital")

db_list <- map(seq_along(db_files$file_name),
    ~ list(
      file_name = db_files$file_name[[.x]],
      table_names = db_files$table_names[[.x]],
      col_names = db_files$col_names[[.x]],
      col_types = db_files$col_types[[.x]]
    ))

t00 <- Sys.time()
for(i in seq_along(db_list)){

  if(i == 1){
    print(glue("Start: {t00} \n \n"))
  }

  db_list_i <- db_list[[i]]

  t01 <- Sys.time()
  print(glue("\n \n \n Start reading - {db_list_i$table_names} - {i}/{max(seq_along(db_list))}"))
  tbl_out <- read_adintel_tsv(
    file = db_list_i$file_name, col_names = db_list_i$col_names, col_types = db_list_i$col_types
  )
  t11 <- Sys.time()
  print(glue("----- done reading"))
  print(t11 - t01)

  names(tbl_out) <- names(tbl_out) %>%
    str_separate_AbCd() %>%
    str_replace("t_v", "tv") %>%
    str_replace("i_d", "id")  %>%
    str_replace("p_c_c", "pcc") %>%
    str_replace("u_c", "uc") %>%
    str_replace("h_h", "hh") %>%
    str_replace("u_r_l", "url")

  t02 <- Sys.time()
  print(glue("\n \n Start uploading to db"))
  DBI::dbWriteTable(conn = con, name = db_list_i$table_names, value = tbl_out, overerwrite = TRUE)
  t12 <- Sys.time()
  print(glue("----- done"))
  print(t12 - t02)

  rm(tbl_out)
  gc()
}
t10 <- Sys.time()
print(t10 - t00)
beepr::beep("fanfare")
