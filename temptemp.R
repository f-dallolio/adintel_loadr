devtools::install_github('f-dallolio/fdutils')
devtools::install_github('f-dallolio/adloadr')
devtools::install_github('f-dallolio/adintelr')

library(DBI)
library(RPostgres)
library(dm)
library(tidyverse)
library(dbplyr)
library(glue)
library(dbcooper)
library(fdutils)
library(adloadr)
library(adintelr)
library(tictoc)


dbname <- 'adintel_14_to_21'
host <- '10.147.18.200'
user <- 'postgres'
password <- "100%Postgres"
con <- connect_db_general(year = 2014, password = password)
new_con <- DBI::dbConnect(RPostgres::Postgres(),
                          dbname = dbname,
                          host = host,
                          port = 5432,
                          user = user,
                          password = password)




tbl_list <- dbListTables(con) %>%
  str_subset("digital", negate = T)

# my_table <- tbl_list[[1]]
my_table <- "tv_spot_local_eng"

dm_df <- dm_from_con(con, my_table) %>% pull_tbl(!!my_table)

grp_vars <- pk_tbl %>% filter(table == my_table) %>% pull(pk)
glue_collapse(grp_vars, ", ")

x <- dm_df %>%
  arrange(ad_date, ad_time, market_code, media_type_id, distributor_code, ad_code) %>%
  mutate(ad_id = cumsum(1), .before = 1)

show_query(.Last.value)



tic()
x <- dm_df %>%
  pivot_longer(prim_brand_code : ter_brand_code,
             names_to = "brand_num",
             values_to = "brand_code") %>%
  filter(brand_code != 0) %>%
  relocate(brand_num, brand_code, .after = media_type_id) %>%
  collect()
toc()
tic()
RPostgres::dbWriteTable(conn = new_con, name = my_table,  value = x)
toc()



dm_df %>%
  arrange(ad_date, market_code, media_type_id, ad_code) %>%
  mutate(ad_id = cumsum(1), .before = 1)


dm_df %>% collect %>%
  slice_head(n = 10) %>%
  write_tsv("~/Downloads/000_test.tsv")
