library(dplyr)
library(brolgar)
# use_data_raw()
wages <- wages %>%
  select(-hgc.9,
         -ue.7,
         -ue.centert1,
         -ue.mean,
         -ue.person.cen,
         -ue1)

usethis::use_data(wages,
                  overwrite = TRUE)
