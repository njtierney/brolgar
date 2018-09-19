library(tidyverse)
library(gghighlight)
library(brolgar)

data(wages)
sl <- l_slope(wages, "id", "lnw~exper")
ns <- l_length(wages, "id", "lnw")
md <-l_median(wages, "id", "lnw")
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

# Stats on stats
wages_enough <- wages %>% 
  left_join(ns, by="id") %>%
  filter(n > 4)
sl <- l_slope(wages_enough, "id", "lnw~exper")
m <- l_median(wages_enough, "id", "lnw")
n <- m %>% filter(!is.na(m)) %>% nrow()
med_n <- ifelse(n%%2==1, (n+1)/2, c(n/2, n/2+1))
indx <- m %>% arrange(m) %>% 
  filter(between(row_number(), med_n[1], med_n[2]))
indx_m <- m %>% arrange(m) %>% 
  filter(row_number() == med_n)
wages_md <- wages_enough %>% filter(id %in% indx_m$id)
ggplot(wages_enough, aes(x=exper, y=lnw, group=id)) + 
  geom_point(alpha=0.1) + 
  geom_line(data=wages_md, colour="orange", size=2)

indx_q <- m %>% arrange(m) %>% 
  filter(between(row_number(), floor(n*0.25), ceiling(n*0.75)))
wages_q <- wages_enough %>% filter(id %in% indx_q$id)
ggplot(wages_enough, aes(x=exper, y=lnw, group=id)) + 
  geom_point(alpha=0.1) + 
  geom_line(data=wages_q, colour="red", alpha=0.5) +
  geom_line(data=wages_md, colour="orange", size=2)

qrt <- c(1, floor(n*0.25), round(n*0.5, 0), ceiling(n*0.75), n)
indx <- m %>% arrange(m) %>% 
  filter(row_number() %in% qrt)
wages_q <- wages_enough %>% filter(id %in% indx$id)
wages_q$id <- factor(wages_q$id, levels=indx$id)
ggplot() + 
  geom_point(data=wages_enough, aes(x=exper, y=lnw), alpha=0.1) + 
  geom_line(data=wages_q, aes(x=exper, y=lnw, group=id, colour=id), size=2) +
  scale_colour_viridis_d()
