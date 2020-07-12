library(dplyr)
library(brolgar)
library(tsibble)

# The original `wages` data from ggobi: http://ggobi.org/book/index.html
# but downloaded from https://github.com/tprvan/brolgar/tree/master/data
# and converted to `rds` object
wages_og <- readr::read_rds("data-raw/wages-original.rds")

wages_og

wages <- wages_og %>%
  dplyr::select(-hgc.9,
                -ue.7,
                -ue.centert1,
                -ue.mean,
                -ue.person.cen,
                -ue1) %>%
  as_tsibble(x = .,
             key = id,
             index = exper,
             regular = FALSE) %>%
  rename(ln_wages = lnw,
         xp = exper,
         high_grade = hgc,
         xp_since_ged = postexp,
         unemploy_rate = uerate)

usethis::use_data(wages,
                  overwrite = TRUE)
