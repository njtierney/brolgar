library(dplyr)
library(brolgar)
library(tsibble)

wages_ts <- as_tsibble(x = wages,
                       key = id,
                       index = exper,
                       regular = FALSE)

usethis::use_data(wages_ts,
                  overwrite = TRUE)
