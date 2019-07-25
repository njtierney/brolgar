library(readxl)
library(here)
library(dplyr)
library(tsibble)
library(countrycode)

heights <- read_excel(here("data-raw",
                           "Height_Compact.xlsx"),
                      sheet = 2) %>%
  rename(country = country.name,
         height_cm = value) %>%
  select(-ccode) %>%
  arrange(country) %>% 
  mutate(continent = countrycode(sourcevar = country,
                                 origin = "country.name",
                                 destination = "continent")) %>%
  as_tsibble(key = country,
             index = year,
             regular = FALSE)

usethis::use_data(heights, overwrite = TRUE)
