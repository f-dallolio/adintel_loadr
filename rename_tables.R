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

tbls <- media_layout %>%
  filter(old_table == "network_tv") %>%
  pull(new_table)


x <- adintel_tbl(table_name = tbls[[1]])

adintel_tv_network_national_eng()

names_foo <- function(...){
  names(enquos(..., .named = TRUE))
}

tv_network_national_eng <- names_foo(
  AdDate, AdTime, MarketCode, MediaTypeID, DistributorCode,
  AdCode, GrpPercentage, MonitorPlusProgramCode
  )
tv_network_national_spa <- names_foo(
  AdDate, AdTime, MarketCode, MediatTypeID, DistributorCode,
  AdCode, MonitorPlusProgramCode
  )
tv_cable_national_eng <- names_foo(
  AdDate, AdTime, MarketCode, MediaTypeID, DistributorCode,
  AdCode, MonitorPlusProgramCode
  )
tv_cable_national_spa <-  names_foo(
  AdDate, AdTime, MarketCode, MediaTypeID, DistributorCode,
  AdCode
  )
tv_syndicated_national_eng <- names_foo(
  AdDate, AdTime, MarketCode, MediaTypeID, DistributorCode,
  AdCode, NielsenProgramCode, TelecastNumber
  )

tv_cable_local_eng <-
  tv_network_local_eng <-
  tv_spot_local_eng <-
  tv_syndicated_local_eng <- names_foo(
    AdDate, AdTime, MarketCode,
    MediaTypeID, DistributorCode, AdCode
  )


magazine_national_eng <- 	names_foo(
  AdDate, MarketCode, MediaTypeID,
  DistributorID, Spend, AdCode, AdNumber
)
magazine_local_eng <- names_foo(
  AdDate, MarketCode, MediaTypeID,
  DistributorCode, Spend, AdCode
)

fsi_coupon <- names_foo(
  AdDate, MarketCode, MediaTypeID, AdCode,
  SourceCode, OffValue, CouponID
)

newspaper_local_eng <-
  newspaper_national_eng <- names_foo(
    AdDate, MarketCode, MediaTypeID, DistributorCode,
    Spend, AdCode, NewspAdSize, NewspEventCode, NewspSecCode
  )

radio_network_national_eng <- names_foo(
  AdDate, MarketCode, MediaTypeID,
  DistributorCode, AdCode
)
radio_spot_local_eng <- names_foo(
  AdDate, MarketCode, MediaTypeID, DistributorCode,
  AdCode, AdTime, RadioDaypartID
)

outdoor_national_eng <- names_foo(
  AdDate, MarketCode, MediaTypeID, DistributorCode, AdCode
)

internet_local_eng <-
  internet_national_eng<- names_foo(
    AdDate, MarketCode, MediaTypeID, DistributorCode, AdCode
  )

cinema_national_eng <-
  cinema_local_eng <- names_foo(
    AdDate, MarketCode, MediaTypeID, AdCode
  )

digital_national_eng <- names_foo(
  AdDate, MarketCode, MediaTypeID, DistributorCode, AdCode, AdPlatformId, AdTypeId
)


