devtools::install_github('f-dallolio/fdutils')
devtools::install_github('f-dallolio/adloadr')
devtools::install_github('f-dallolio/adintelr')

library(tidyverse)
library(glue)
library(dbcooper)
library(fdutils)
library(adloadr)
library(adintelr)

con <- connect_db()
dbc_init(con = con, con_id = "adintel", table_formatter = table_formatter)
tbls <- adintel_list() %>% table_formatter()



names_foo <- function(...){
  names(enquos(..., .named = TRUE))
}

pk_list <- list(
  tv_network_national_eng = names_foo(
    AdDate, AdTime, MarketCode, MediaTypeID, DistributorCode,
    AdCode, GrpPercentage, MonitorPlusProgramCode
  ),
  tv_network_national_spa = names_foo(
    AdDate, AdTime, MarketCode, MediaTypeID, DistributorCode,
    AdCode, MonitorPlusProgramCode
  ),
  tv_cable_national_eng = names_foo(
    AdDate, AdTime, MarketCode, MediaTypeID, DistributorCode,
    AdCode, MonitorPlusProgramCode
  ),
  tv_cable_national_spa =  names_foo(
    AdDate, AdTime, MarketCode, MediaTypeID, DistributorCode,
    AdCode
  ),
  tv_syndicated_national_eng = names_foo(
    AdDate, AdTime, MarketCode, MediaTypeID, DistributorCode,
    AdCode, NielsenProgramCode, TelecastNumber
  ),
  tv_cable_local_eng =  names_foo(
    AdDate, AdTime, MarketCode,
    MediaTypeID, DistributorCode, AdCode
  ),
  tv_network_local_eng = names_foo(
    AdDate, AdTime, MarketCode,
    MediaTypeID, DistributorCode, AdCode
  ),
  tv_spot_local_eng = names_foo(
    AdDate, AdTime, MarketCode,
    MediaTypeID, DistributorCode, AdCode
  ),
  tv_syndicated_local_eng = names_foo(
    AdDate, AdTime, MarketCode,
    MediaTypeID, DistributorCode, AdCode
  ),
  magazine_national_eng = 	names_foo(
    AdDate, MarketCode, MediaTypeID,
    DistributorID, Spend, AdCode, AdNumber
  ),
  magazine_local_eng = names_foo(
    AdDate, MarketCode, MediaTypeID,
    DistributorCode, Spend, AdCode
  ),
  coupon_national_eng = names_foo(
    AdDate, MarketCode, MediaTypeID, AdCode,
    SourceCode, OffValue, CouponID
  ),
  newspaper_local_eng = names_foo(
    AdDate, MarketCode, MediaTypeID, DistributorCode,
    Spend, AdCode, NewspAdSize, NewspEventCode, NewspSecCode
  ),
  newspaper_national_eng = names_foo(
      AdDate, MarketCode, MediaTypeID, DistributorCode,
      Spend, AdCode, NewspAdSize, NewspEventCode, NewspSecCode
  ),
  sundaysupplement_local_eng = names_foo(
    AdDate, MarketCode, MediaTypeID, DistributorCode,
    Spend, AdCode, NewspAdSize, NewspEventCode, NewspSecCode
  ),
  sundaysupplement_national_eng = names_foo(
    AdDate, MarketCode, MediaTypeID, DistributorCode,
    Spend, AdCode, NewspAdSize, NewspEventCode, NewspSecCode
  ),
  radio_network_national_eng = names_foo(
    AdDate, MarketCode, MediaTypeID,
    DistributorCode, AdCode
  ),
  radio_spot_local_eng = names_foo(
    AdDate, MarketCode, MediaTypeID, DistributorCode,
    AdCode, AdTime, RadioDaypartID
  ),
  outdoor_national_eng = names_foo(
    # AdDate, MarketCode, MediaTypeID, DistributorCode, AdCode
    AdDate, MarketCode, MediaTypeID, AdCode, AdTypeID
  ),
  internet_local_eng = names_foo(
    AdDate, MarketCode, MediaTypeID, DistributorCode, AdCode
  ),
  internet_national_eng = names_foo(
      AdDate, MarketCode, MediaTypeID, DistributorCode, AdCode
  ),
  cinema_national_eng = names_foo(
    AdDate, MarketCode, MediaTypeID, AdCode
  ),
  cinema_local_eng = names_foo(
      AdDate, MarketCode, MediaTypeID, AdCode
  ),
  digital_national_eng = names_foo(
    AdDate, MarketCode, MediaTypeID, DistributorCode,
    AdCode, AdPlatformId, AdTypeId
  )
)

xxx <- map2(.x = names(pk_list), .y = pk_list, .f = ~ tibble(new_table = .x, pk = .y)) %>%
  list_rbind() %>%
  mutate(pk = pk %>%
           str_upper_split() %>%
           str_replace_all("i_d", "id")) %>%
  nest(pk = pk, .by = new_table) %>%
  mutate(pk = pk %>% modify(~ .x %>% pull()))

media_temp <- media_layout %>% inner_join(xxx) %>%
  select(new_table, pk) %>%
  filter(new_table %in% tbls)


library(dm)
dm_df <- dm_from_con(con, media_temp$new_table)

seq_id <- seq_along(media_temp$pk)
i=5

for(i in seq_id){
  print(i)
  table <-  media_temp$new_table[[i]]
  columns <- media_temp$pk[[i]]
  # dm_df <- dm_df %>%
  #   dm_add_pk(table = !!table, columns = columns, force = TRUE, check = TRUE)

  dm_df %>%
    dm_add_pk(table = !!table, columns = columns, force = TRUE) %>% dm_examine_constraints()
}

adintel_outdoor_national_eng() %>%

  summarise(spend = sum(spend), .by = c(ad_date, market_code, media_type_id, ad_code, ad_type_id)) %>%
  show_query()


dm(table) %>%
  dm_add_pk(table = table, columns = c(ad_date, market_code, media_type_id, ad_code, ad_type_id), force = TRUE) %>% dm_examine_constraints()



skimr::skim()


dm_df %>%
  dm_add_pk(table = !!table, columns = columns, force = TRUE)

dm_df %>% dm_examine_constraints()





