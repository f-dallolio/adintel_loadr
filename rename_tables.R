devtools::install_github('f-dallolio/fdutils')
devtools::install_github('f-dallolio/adloadr')
devtools::install_github('f-dallolio/adintelr')

library(tidyverse)
library(glue)
library(dbcooper)
library(fdutils)
library(adloadr)
library(adintelr)

exceptions = list(t_v = 'tv', i_d = 'id', p_c_c = "pcc", u_c = 'uc', h_h = "hh")

years = 2014:2018
password <- rstudioapi::askForPassword()

