library(readxl)
library(here)
library(dplyr)
library(tsibble)
library(countrycode)
library(brolgar)

heights <- 
  read_excel(here("data-raw",
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
             regular = FALSE) %>% 
  add_n_obs() %>% 
  filter(n_obs > 1) %>% 
  select(country, continent, year, height_cm)

heights

usethis::use_data(heights, overwrite = TRUE)
