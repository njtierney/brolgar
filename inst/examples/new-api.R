library(tsibble)
wages_ts <- as_tsibble(x = wages,
                       key = id, # the thing that identifies each distinct series
                       index = exper, # the time part
                       regular = FALSE) # important for the 

wages_ts

wages_lm <- lm(lnw ~ exper, wages_ts)

?wages

wages %>%
  l_slope(id = id,
          formula = lnw ~ exper)

###

library(feasts)
library(tsibbledata)

slope <- function(x, ...){
  # `names<-`(coef(lm(x ~ seq_along(x))), c("int", "slope"))
  setNames(coef(lm(x ~ seq_along(x))), c("int", "slope"))
}

library(dplyr)
aus_retail %>% 
  features(Turnover, stl_features) %>% 
  filter(seasonal_strength.year %in% range(seasonal_strength.year)) %>% 
  semi_join(aus_retail, ., by = c("State", "Industry")) %>% 
  autoplot(Turnover)




aus_retail %>% 
  features(Turnover, crossing_points) %>% 
  filter(nearest_qt(seasonal_strength.year, type = 8)) %>% 
  semi_join(aus_retail, ., by = c("State", "Industry")) %>% 
  autoplot(Turnover)
# summarise(seas_strength = list(as_tibble(as.list(quantile(seasonal_strength.year, type = 8))))) %>% 
# tidyr::unnest()


library(fable)
.resid <- aus_retail %>% 
  model(SNAIVE(Turnover)) %>% 
  residuals()


.resid %>% 
  filter(!is.na(.resid), length(.resid) > 24) %>% 
  features(.resid, slope) %>% 
  filter(nearest_qt(slope, type = 8)) %>% 
  semi_join(aus_retail, ., by = c("State", "Industry")) %>% 
  autoplot(Turnover)


aus_retail %>% 
  filter(Industry == "Other specialised food retailing") %>% 
  autoplot(Turnover)
