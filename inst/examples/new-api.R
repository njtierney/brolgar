library(tsibble)
library(brolgar)

world_heights %>%
  filter(nearest_qt(height_cm))

# we need a way to add a label of the quantiles so we can plot them on top of 
# the data.



heights <- as_tsibble(x = world_heights,
                      key = country,
                      index = year,
                      regular = FALSE)

library(feasts)

heights %>%
  features(features = count)

heights_qs <- heights %>%
  filter(nearest_qt(height_cm)) %>%
  semi_join(heights, ., by = "country") 

autoplot(heights_qs, .vars = height_cm)

library(ggplot2)
library(gghighlight)
ggplot(heights,
       aes(x = year,
           y = height_cm,
           group = country)) + 
  geom_line() +
  gghighlight()

wages_ts <- as_tsibble(x = wages,
                       key = id, # the thing that identifies each distinct series
                       index = exper, # the time part
                       regular = FALSE) # important for longitudinal data

wages_ts

heights <- as_tsibble(x = world_heights,
                      key = country,
                      index = year,
                      regular = FALSE)

l_fivenum <- list(min = b_min,
                  max = b_max,
                  median = b_median,
                  q1 = b_q25,
                  q3 = b_q75)

heights %>% 
  add_l_slope(id)
  summarise_at(vars(height_cm),
               l_fivenum)

wages_lm <- lm(lnw ~ exper, wages_ts)

wages %>%
  l_slope(id = id,
          formula = lnw ~ exper)

library(feasts)
library(tsibbledata)

slope <- function(x, ...){
  setNames(coef(lm(x ~ seq_along(x))), c("int", "slope"))
}

library(dplyr)
aus_retail %>% 
  features(Turnover, features_stl) %>% 
  filter(seasonal_strength_year %in% range(seasonal_strength_year)) %>% 
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
