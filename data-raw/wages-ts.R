library(dplyr)
library(brolgar)
library(tsibble)

wages_ts <- as_tsibble(x = wages,
                       key = id,
                       index = exper,
                       regular = FALSE) %>%
  rename(ln_wages = lnw,
         xp = exper,
         high_grade = hgc,
         xp_since_ged = postexp,
         unemploy_rate = uerate)

usethis::use_data(wages_ts,
                  overwrite = TRUE)
