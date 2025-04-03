# Since Nick took over
library(tidyverse)
library(brolgar)

lwage <- longnostic_all(wages, id = id, var = lnw, formula = lnw ~ exper)
lwage <- lwage %>% filter(l_n_obs > 2)

library(tourr)
quartz()
animate_xy(lwage[, -1], axes = "bottomleft")

# Old code
library(gghighlight)

data(wages)
sl <- l_slope(wages, "id", "lnw~exper")
ns <- l_length(wages, "id", "lnw")
md <- l_median(wages, "id", "lnw")
min1 <- l_min(wages, "id", "lnw")
wages_lg <- wages %>%
  left_join(sl, by = "id") %>%
  left_join(ns, by = "id")

# Without gghighlight
wages_lg_enough <- wages_lg %>% filter(n > 5)
ggplot(wages_lg_enough, aes(x = exper, y = lnw, group = id)) +
  geom_line(colour = "grey80", alpha = 0.5) +
  geom_line(
    data = filter(wages_lg_enough, slope < (-0.5)),
    aes(colour = factor(id))
  ) +
  scale_colour_brewer("", palette = "Dark2") +
  xlab("Years in workforce") +
  ylab("Log_e hourly wages")

ggplot(wages_lg_enough, aes(x = exper, y = lnw, group = id)) +
  geom_line(colour = "grey80", alpha = 0.5) +
  geom_line(
    data = filter(wages_lg_enough, slope > 0.3),
    aes(colour = factor(id))
  ) +
  scale_colour_brewer("", palette = "Dark2") +
  xlab("Years in workforce") +
  ylab("Log_e hourly wages")

# Code with gghighlight
wages_lg %>%
  filter(n > 5) %>%
  ggplot(aes(x = exper, y = lnw, group = id)) +
  geom_line() +
  gghighlight(slope < (-0.5), use_direct_label = FALSE)

ggplot(wages_lg, aes(x = exper, y = lnw, group = id)) +
  geom_line() +
  gghighlight(slope > 2, use_direct_label = FALSE)

ggplot(sl, aes(x = slope)) + geom_histogram()

# Stats on stats
wages_enough <- wages %>%
  left_join(ns, by = "id") %>%
  filter(n > 4)
sl <- l_slope(wages_enough, "id", "lnw~exper")
m <- l_median(wages_enough, "id", "lnw")
# min1<-l_min(wages_enough,"id","lnw")
n <- m %>% filter(!is.na(m)) %>% nrow()
med_n <- ifelse(n %% 2 == 1, (n + 1) / 2, c(n / 2, n / 2 + 1))
indx <- m %>%
  arrange(m, m) %>%
  filter(between(row_number(), med_n[1], med_n[2]))
indx_m <- m %>% arrange(m, m) %>% filter(row_number() == med_n)
wages_md <- wages_enough %>% filter(id %in% indx_m$id)
ggplot(wages_enough, aes(x = exper, y = lnw, group = id)) +
  geom_point(alpha = 0.1) +
  geom_line(data = wages_md, colour = "orange", size = 2)

indx_q <- m %>%
  arrange(m, m) %>%
  filter(between(row_number(), floor(n * 0.25), ceiling(n * 0.75)))
wages_q <- wages_enough %>% filter(id %in% indx_q$id)
ggplot(wages_enough, aes(x = exper, y = lnw, group = id)) +
  geom_point(alpha = 0.1) +
  geom_line(data = wages_q, colour = "red", alpha = 0.5) +
  geom_line(data = wages_md, colour = "orange", size = 2)

qrt <- c(1, floor(n * 0.25), round(n * 0.5, 0), ceiling(n * 0.75), n)
indx <- m %>% arrange(m, m) %>% filter(row_number() %in% qrt)
wages_q <- wages_enough %>% filter(id %in% indx$id)
wages_q$id <- factor(wages_q$id, levels = indx$id)
ggplot() +
  geom_point(data = wages_enough, aes(x = exper, y = lnw), alpha = 0.1) +
  geom_line(
    data = wages_q,
    aes(x = exper, y = lnw, group = id, colour = id),
    size = 2
  ) +
  scale_colour_viridis_d()

# For min
#
# sl <- l_slope(wages_enough, "id", "lnw~exper")
# m <- l_median(wages_enough, "id", "lnw")
min1 <- l_min(wages_enough, "id", "lnw")


min1_n <- which(min1[, 2] == min(min1[, 2]))
min1_id <- min1[min1_n, 1]

min1_nmax <- which(min1[, 2] == max(min1[, 2]))
min1_idmax <- min1[min1_nmax, 1]

# test<-filter(wages_enough,id==min1_id[[1]]) #now works

ggplot(wages_enough, aes(x = exper, y = lnw, group = id)) +
  geom_point(alpha = 0.1) +
  geom_line(
    data = filter(wages_enough, id == min1_id[[1]]),
    colour = "blue",
    size = 2
  ) +
  geom_line(
    data = filter(wages_enough, id == min1_idmax[[1]]),
    colour = "red",
    size = 2
  )


max1 <- l_max(wages_enough, "id", "lnw")
max1_nmin <- which(max1[, 2] == min(max1[, 2]))
max1_idmin <- max1[max1_nmin, 1]

max1_nmax <- which(max1[, 2] == max(max1[, 2]))
max1_idmax <- max1[max1_nmax, 1]

ggplot(wages_enough, aes(x = exper, y = lnw, group = id)) +
  geom_point(alpha = 0.1) +
  geom_line(
    data = filter(wages_enough, id == max1_idmin[[1]]),
    colour = "blue",
    size = 2
  ) +
  geom_line(
    data = filter(wages_enough, id == max1_idmax[[1]]),
    colour = "red",
    size = 2
  )


indx_q1min1 <- min1 %>%
  arrange(min1, m) %>%
  filter(between(row_number(), floor(n * 0.25), ceiling(n * 0.75))) #doesn't work
wages_q1min1 <- wages_enough %>% filter(id %in% indx_q1min$id)
ggplot(wages_enough, aes(x = exper, y = lnw, group = id)) +
  geom_point(alpha = 0.1) +
  geom_line(data = wages_q, colour = "red", alpha = 0.5) +
  geom_line(data = wages_md, colour = "orange", size = 2)

qrt <- c(1, floor(n * 0.25), round(n * 0.5, 0), ceiling(n * 0.75), n)
indx <- min1 %>% arrange(min1, m) %>% filter(row_number() %in% qrt) ### not changed yet
wages_q <- wages_enough %>% filter(id %in% indx$id)
wages_q$id <- factor(wages_q$id, levels = indx$id)
ggplot() +
  geom_point(data = wages_enough, aes(x = exper, y = lnw), alpha = 0.1) +
  geom_line(
    data = wages_q,
    aes(x = exper, y = lnw, group = id, colour = id),
    size = 2
  ) +
  scale_colour_viridis_d()
