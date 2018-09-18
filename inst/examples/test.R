library(tidyverse)
library(gghighlight)
library(brolgar)

data(wages)
sl <- l_slope(wages, "id", "lnw~exper")
ns <- l_length(wages, "id", "lnw")
wages_lg <- wages %>% 
  left_join(sl, by="id") %>%
  left_join(ns, by="id")

# Without gghighlight
wages_lg_enough <- wages_lg %>% filter(n>5) 
ggplot(wages_lg_enough, aes(x=exper, y=lnw, group=id)) + 
  geom_line(colour="grey80", alpha=0.5) +
  geom_line(data=filter(wages_lg_enough, slope < (-0.5)), 
            aes(colour=factor(id))) + 
  scale_colour_brewer("", palette="Dark2") +
  xlab("Years in workforce") +
  ylab("Log_e hourly wages")

ggplot(wages_lg_enough, aes(x=exper, y=lnw, group=id)) + 
  geom_line(colour="grey80", alpha=0.5) +
  geom_line(data=filter(wages_lg_enough, slope > 0.3), 
            aes(colour=factor(id))) + 
  scale_colour_brewer("", palette="Dark2") +
  xlab("Years in workforce") +
  ylab("Log_e hourly wages")

# Code with gghighlight
wages_lg %>% filter(n>5) %>% 
  ggplot(aes(x=exper, y=lnw, group=id)) + geom_line() +
  gghighlight(slope < (-0.5), use_direct_label=FALSE)

ggplot(wages_lg, aes(x=exper, y=lnw, group=id)) + geom_line() +
  gghighlight(slope > 2, use_direct_label=FALSE)

ggplot(m, aes(x=slope)) + geom_histogram()