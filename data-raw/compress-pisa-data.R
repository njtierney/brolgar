# install.packages("remotes")
# remotes::install_github("ropenscilabs/learningtower")
library(learningtower)
library(brolgar)
library(tsibble)
library(tidyverse)

pisa <- student %>% 
  select(year:student_id,
         gender,
         math:stu_wgt) %>% 
  filter(country %in% c(
    "AUS", # Australia
    "BRA", # Brazil
    "CHL", # Chile
    "DNK", # Denmark
    "FRA", # France
    "GRC", # Greece
    "HKG", # Hong Kong
    "IDN" # Indonesia
    # "JPN", # Japan
    # "LBY", # Libya
    # "MEX", # Mexico,
    # "NZL", # New Zealand
    # "RUS", # Russia
    # "THA", # Thailand
    # "USA" # United states of America
    )) %>%
  mutate_at(vars(school_id, student_id),
            as.integer) %>%
  mutate(country = fct_drop(country))

pryr::object_size(pisa)

duplicates(pisa,
           key = c(country, school_id, student_id),
           index = year) %>% 
  arrange(year, school_id, student_id) %>% pull(student_id)

unique(pisa$country)

arrange(pisa, n_obs)

barplot(table(pisa$country))


plot(table(pisa$year))

usethis::use_data(pisa, compress = "xz", overwrite = TRUE)
