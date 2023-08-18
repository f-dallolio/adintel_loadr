devtools::install_github('f-dallolio/fdutils')
devtools::install_github('f-dallolio/adloadr')
devtools::install_github('f-dallolio/adintelr')

library(DBI)
library(RPostgres)
library(tidyverse)
library(glue)
library(dbcooper)
library(fdutils)
library(adloadr)
library(adintelr)

references_pk <- references_pk %>%
  unnest(everything()) %>%
  mutate(pk = pk %>% str_separate_AbCd() %>%
           str_replace_all("i_d", "id") %>%
           str_replace_all("t_v", "tv")) %>%
  summarise(pk = list(pk), .by = tablename)
usethis::use_data(references_pk, overwrite = TRUE)


loader_tbl_references <- loader_tbl_references %>%
  unnest(col_names) %>%
  mutate(col_names_ok = col_names %>%
           str_separate_AbCd() %>%
           str_replace_all("i_d", "id") %>%
           str_replace_all("t_v", "tv") %>%
           str_replace_all("p_c_c", "pcc") %>%
           str_replace_all("u_r_l", "url")) %>%
  summarise(across(col_names : col_names_ok, list),
            .by = c(filetype, dir, file, tablename)) %>%
  mutate(col_types = map(col_types, pluck(1)))
usethis::use_data(loader_tbl_references, overwrite = TRUE)


loader_tbl_occurrences <- loader_tbl_occurrences %>%
  unnest(col_names) %>%
  mutate(col_names_ok = col_names %>%
           str_separate_AbCd() %>%
           str_replace_all("i_d", "id") %>%
           str_replace_all("t_v", "tv") %>%
           str_replace_all("p_c_c", "pcc") %>%
           str_replace_all("u_r_l", "url") %>%
           str_replace_all("u_c", "uc") %>%
           str_replace_all("__", "_")) %>%
  summarise(across(col_names : col_names_ok, list),
            .by = c(filetype, dir, file, tablename)) %>%
  mutate(col_types = map(col_types, pluck(1)))
usethis::use_data(loader_tbl_occurrences, overwrite = TRUE)




