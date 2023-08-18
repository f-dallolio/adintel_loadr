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

password <- "100%Postgres"
con <- connect_db_general(year = 2014, password = password)

tbl_list <- dbListTables(con)
tbl_list <- tbl_list %>% map(~ dbListFields(con = con, name = .x)) %>% set_names(tbl_list)
occurences_columns <- imap(tbl_list, ~ tibble(table = .y, col_names = .x)) %>%
  list_rbind() %>%
  rename(columns = col_names)

references_pk %>%
  unnest(everything()) %>%
  rename(ref = tablename,
         columns = pk) %>%
  inner_join(occurences_columns) %>%
  summarise(columns = columns %>% list(), .by = c(table, ref))
