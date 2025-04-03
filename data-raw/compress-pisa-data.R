# install.packages("remotes")
# remotes::install_github("ropenscilabs/learningtower")
library(learningtower)
library(brolgar)
library(tsibble)
library(tidyverse)

pisa <- student %>%
  select(year:student_id, gender, math:stu_wgt) %>%
  group_by(country, year) %>%
  summarise(
    math_mean = weighted.mean(math, stu_wgt, na.rm = TRUE),
    read_mean = weighted.mean(read, stu_wgt, na.rm = TRUE),
    science_mean = weighted.mean(science, stu_wgt, na.rm = TRUE),
    math_max = max(math, na.rm = TRUE),
    read_max = max(read, na.rm = TRUE),
    science_max = max(science, na.rm = TRUE),
    math_min = min(math, na.rm = TRUE),
    read_min = min(read, na.rm = TRUE),
    science_min = min(science, na.rm = TRUE)
  ) %>%
  ungroup() %>%
  mutate(country = fct_drop(country), year = as.integer(as.character(year))) %>%
  relocate(math_min, math_max, .after = math_mean) %>%
  relocate(read_min, read_max, .after = read_mean) %>%
  relocate(science_min, science_max, .after = science_mean)

pisa

pryr::object_size(pisa)

unique(pisa$country)

barplot(table(pisa$country))

plot(table(pisa$year))

usethis::use_data(pisa, compress = "xz", overwrite = TRUE)
