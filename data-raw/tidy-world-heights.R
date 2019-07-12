library(readxl)
library(here)
library(dplyr)
library(tsibble)

world_heights <- read_excel(here("data-raw",
                                 "Height_Compact.xlsx"),
                                       sheet = 2) %>%
  rename(country = country.name,
                height_cm = value) %>%
  select(-ccode) %>%
  arrange(country) %>%
  as_tsibble(key = country,
             index = year,
             regular = FALSE)

usethis::use_data(world_heights, overwrite = TRUE)
