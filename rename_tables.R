devtools::install_github('f-dallolio/fdutils')
devtools::install_github('f-dallolio/adloadr')
devtools::install_github('f-dallolio/adintelr')

library(tidyverse)
library(glue)
library(dbcooper)
library(fdutils)
library(adloadr)
library(adintelr)

con <- connect_db_general(year = 2014, password = '100%Postgres')
dbc_init(con = con, con_id = "x", table_formatter = table_formatter)
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

pk_tbl <- imap(pk_list, ~ tibble(table = .y, pk = .x)) %>%
  list_rbind() %>%
  mutate(
    pk = pk %>% str_separate_AbCd() %>%
      str_replace_all("t_v", "tv") %>%
      str_replace_all("i_d", "id") %>%
      str_replace_all("u_c", "uc") %>%
      str_replace_all("h_h", "hh") %>%
      str_replace_all("p_c_c", "pcc") %>%
      str_replace_all("u_r_l", "url")  %>%
      str_replace_all("__", "_")
  )

usethis::use_data(pk_tbl)
