#' Calculating longnostics - statistics of interest for each individual
#' 
#' Calculate statistical summaries for each individual, referred to as a
#'   **longnostics**, a portmanteau of **long**itudinal and **cognostic** - a 
#'   term coined by Tukey which is itself a portmanteau of "cognitive" and 
#'   "diagnostic". These **longnostics** all start with `l_`, and calculate
#'   a statistic for each individual in the data, who can be identified with
#'   some `id`, with the statistic being calculated for a specific variable.
#'   The current **longnostics** implemented are:
#'   
#'  * `l_n_obs()` Number of observations
#'  * `l_min()` Minimum
#'  * `l_max()` Maximum
#'  * `l_mean()` Mean
#'  * `l_diff()` Lagged difference (by default, the first order difference)
#'  * `l_q1()` First quartile
#'  * `l_median()` Median value
#'  * `l_q3()` Third quartile
#'  * `l_sd()` Standard deviation
#'  * `l_slope()` Slope and intercept (given some linear model formula)
#' 
#' @param data data.frame to explore
#' @param var vector of values for individuals, needs to match the id vector
#' @param id vector of ids to define which values belong to which individual
#' @param lag the lag to use, default to 1 (used with `l_diff`)
#' @param formula character, a formula representing the slope of interest (used in `l_slope`)
#' @return dataframe with column id and l_`statistic`. For example, `l_mean` returns the columns id specified, and `l_mean`.
#' @name l_longnostic
#' @seealso The add_l_`statistic` set of functions which add a column for each id to the dataframe.
#' @examples
#' l_mean(wages, id, lnw)
#' l_sd(wages, id, lnw)
#' l_max(wages, id, lnw)
#' l_min(wages, id, lnw)
#' l_median(wages, id, lnw)
#' l_q1(wages, id, lnw)
#' l_diff(wages, id, lnw)
#' l_diff(wages, id, lnw, lag = 2)
#' l_q3(wages, id, lnw)
#' l_n_obs(wages, id, lnw)
#' l_slope(wages, id, lnw~exper)
NULL

#' @rdname l_longnostic
#' @export
l_mean <- function(data, id, var) {
  
  q_id <- rlang::enquo(id)
  q_var <- rlang::enquo(var)
  
  longnostic(data = data,
               id = !!q_id,
               var = !!q_var,
               statistic =  mean,
               l_name = l_mean,
               na.rm = TRUE)
}

#' @rdname l_longnostic
#' @export
l_sd <- function(data, id, var) {

  q_id <- rlang::enquo(id)
  q_var <- rlang::enquo(var)
  
  longnostic(data = data,
               id = !!q_id,
               var = !!q_var,
               statistic =  sd,
               l_name = l_sd,
               na.rm = TRUE)
  
}

#' @rdname l_longnostic
#' @export
l_max <- function(data, id, var) {
  
  q_id <- rlang::enquo(id)
  q_var <- rlang::enquo(var)
  
  longnostic(data = data,
               id = !!q_id,
               var = !!q_var,
               statistic =  max,
               l_name = l_max,
               na.rm = TRUE)
  
}

#' @rdname l_longnostic
#' @export
l_min <- function(data, id, var) {
  
  q_id <- rlang::enquo(id)
  q_var <- rlang::enquo(var)
  
  longnostic(data = data,
               id = !!q_id,
               var = !!q_var,
               statistic =  min,
               l_name = l_min,
               na.rm = TRUE)
}

#' @rdname l_longnostic
#' @export
l_median <- function(data, id, var) {
  
  q_id <- rlang::enquo(id)
  q_var <- rlang::enquo(var)
  
  longnostic(data = data,
               id = !!q_id,
               var = !!q_var,
               statistic = median,
               l_name = l_median,
               na.rm = TRUE)
}

#' @rdname l_longnostic
#' @export
l_q1 <- function(data, id, var) {
  
  q_id <- rlang::enquo(id)
  q_var <- rlang::enquo(var)
  
  longnostic(data = data,
               id = !!q_id,
               var = !!q_var,
               statistic = quantile,
               l_name = l_q1,
               probs = c(0.25),
               type = 7,
               na.rm = TRUE)
  
}

#' @rdname l_longnostic
#' @export
l_q3 <- function(data, id, var) {
  
  q_id <- rlang::enquo(id)
  q_var <- rlang::enquo(var)
  
  longnostic(data = data,
               id = !!q_id,
               var = !!q_var,
               statistic = quantile,
               l_name = l_q3,
               probs = c(0.75),
               type = 7,
               na.rm = TRUE)
}

#' @rdname l_longnostic
#' @export
l_diff <- function(data, id, var, lag = 1) {
  
  q_id <- rlang::enquo(id)
  q_var <- rlang::enquo(var)
  
  safe_diff <- function(x, ...) max_if(diff(x, ...))
  
  l_name <- rlang::sym(glue::glue("l_diff_{lag}"))
  
  longnostic(data = data,
               id = !!q_id,
               var = !!q_var,
               statistic = safe_diff,
               l_name = !!l_name,
               lag = lag,
               na.rm = TRUE)
}

#' @rdname l_longnostic
#' @export
l_n_obs <- function(data, id, var) {
  
  q_id <- rlang::enquo(id)
  q_var <- rlang::enquo(var)
  
  longnostic(data = data,
               id = !!q_id,
               var = !!q_var,
               statistic = length,
               l_name = l_n_obs)
  
}

#' @rdname l_longnostic
#' @export
l_slope <- function(data, id, formula) {
  
  quo_id <- rlang::enquo(id)
  quo_formula <- rlang::enquo(formula)
  
  data %>%
    dplyr::group_by(!!quo_id) %>%
    dplyr::group_map(~broom::tidy(lm(quo_formula, data = .x))) %>%
    dplyr::select(id,
                  term,
                  estimate) %>%
    tidyr::spread(key = term,
                  value = estimate) %>%
    dplyr::rename_all(~c("id", "l_intercept", "l_slope"))

  # 
  # l_slope_old <- function(df, id, formula){
  #   l <- split(df, df[[id]])
  #   sl <- purrr::map(l, ~ eval(substitute(lm(formula, data = .)))) %>%
  #     purrr::map_dfr( ~ as.data.frame(t(as.matrix(coef(
  #       .
  #     ))))) %>%
  #     dplyr::mutate(id = as.integer(names(l))) %>%
  #     dplyr::rename_all( ~ c("intercept", "slope", "id")) %>%
  #     dplyr::select(id, intercept, slope) %>%
  #     tibble::as_tibble()
  #   return(sl)
  # }
  
}

#' @rdname l_longnostic
#' @export
future_l_slope <- function(data, id, formula) {
  
  # future::plan(multiprocess)
  
  quo_id <- rlang::enquo(id)
  quo_formula <- rlang::enquo(formula)
  
  data %>%
    dplyr::group_by(!!quo_id) %>%
    tidyr::nest() %>%
    dplyr::mutate(tidy_lm = furrr::future_map(
      .f = function(data) broom::tidy(lm(!!quo_formula, data = data)),
      .x = data)) %>%
    dplyr::select(!!quo_id,
                  tidy_lm) %>%
    tidyr::unnest() %>%
    dplyr::select(!!quo_id,
                  term,
                  estimate) %>%
    tidyr::spread(key = term,
                  value = estimate) %>%
    dplyr::rename_all(~c("id", "l_intercept", "l_slope"))
}

# bm1 <-
#   microbenchmark::microbenchmark(future = future_l_slope(wages, id, lnw~exper),
#                                  current = l_slope(wages, id, lnw~exper))
# 
# summary(bm1)
# boxplot(bm1)
