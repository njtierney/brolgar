#' Calculating lognostics
#' 
#' Lognostics are Cognitive Diagnostics for longitudinal data
#' 
#' @param data data.frame to explore
#' @param var vector of values for individuals, needs to match the id vector
#' @param id vector of ids to define which values belong to which individual
#' @name lognostic
NULL

#' Index of interestingness: mean
#'
#' Compute the mean for all individuals in the data
#'
#' @inheritParams lognostic
#' @export
#' @examples
#' data(wages)
#' l_mean(wages, "id", "lnw")
#'
l_mean <- function(data, id, var) {
  
  q_id <- rlang::enquo(id)
  q_var <- rlang::enquo(var)
  
  lognosticise(data = data,
               id = !!q_id,
               var = !!q_var,
               statistic =  mean,
               l_name = l_mean,
               na.rm = TRUE)
}

#' Index of interestingness: sd
#'
#' Compute the standard deviation for all individuals in the data
#'
#' @inheritParams lognostic
#' @export
#' @examples
#' data(wages)
#' l_sd(wages, "id", "lnw")
#'
l_sd <- function(data, id, var) {

  q_id <- rlang::enquo(id)
  q_var <- rlang::enquo(var)
  
  lognosticise(data = data,
               id = !!q_id,
               var = !!q_var,
               statistic =  sd,
               l_name = l_sd,
               na.rm = TRUE)
  
}

#' Index of interestingness: max
#'
#' Compute the maximum value for all individuals in the data
#'
#' @inheritParams lognostic
#' @export
#' @examples
#' data(wages)
#' l_max(wages, "id", "lnw")
#'
l_max <- function(data, id, var) {
  
  q_id <- rlang::enquo(id)
  q_var <- rlang::enquo(var)
  
  lognosticise(data = data,
               id = !!q_id,
               var = !!q_var,
               statistic =  max,
               l_name = l_max,
               na.rm = TRUE)
  
}

#' Index of interestingness: min
#'
#' Compute the minimum value for all individuals in the data

#' @inheritParams lognostic
#' @export
#' @examples
#' data(wages)
#' l_min(wages, "id", "lnw")
#'
l_min <- function(data, id, var) {
  
  q_id <- rlang::enquo(id)
  q_var <- rlang::enquo(var)
  
  lognosticise(data = data,
               id = !!q_id,
               var = !!q_var,
               statistic =  min,
               l_name = l_min,
               na.rm = TRUE)
}

#' Index of interestingness: median
#'
#' Compute the median value for all individuals in the data
#' @inheritParams lognostic
#' @export
#' @examples
#' data(wages)
#' l_median(wages, id, lnw)
#'
l_median <- function(data, id, var) {
  
  q_id <- rlang::enquo(id)
  q_var <- rlang::enquo(var)
  
  lognosticise(data = data,
               id = !!q_id,
               var = !!q_var,
               statistic = median,
               l_name = l_median,
               na.rm = TRUE)
}

#' Index of interestingness: first quartile
#'
#' Compute the first quartile value for all individuals in the data

#' @inheritParams lognostic
#' @export
#' @examples
#' data(wages)
#' l_q1(wages, id, lnw)
#'
l_q1 <- function(data, id, var) {
  
  q_id <- rlang::enquo(id)
  q_var <- rlang::enquo(var)
  
  lognosticise(data = data,
               id = !!q_id,
               var = !!q_var,
               statistic = quantile,
               l_name = l_q1,
               probs = c(0.25),
               type = 7,
               na.rm = TRUE)
  
}

#' Index of interestingness: third quartile
#'
#' Compute the third quartile value for all individuals in the data

#' @inheritParams lognostic
#' @export
#' @examples
#' data(wages)
#' l_q3(wages, id, lnw)
#'
l_q3 <- function(data, id, var) {
  
  q_id <- rlang::enquo(id)
  q_var <- rlang::enquo(var)
  
  lognosticise(data = data,
               id = !!q_id,
               var = !!q_var,
               statistic = quantile,
               l_name = l_q3,
               probs = c(0.75),
               type = 7,
               na.rm = TRUE)
}

#' Index of interestingness: first order difference
#' Need to revisit for missing values
#'
#' Compute the maximum of the first order difference of consecutive values for all individuals in the data

#' @inheritParams lognostic
#' @param lag the lag to use, default to 1
#' @export
#' @examples
#' data(wages)
#' l_diff(wages, id, lnw)
#'
l_diff <- function(data, id, var, lag = 1) {
  
  q_id <- rlang::enquo(id)
  q_var <- rlang::enquo(var)
  
  safe_diff <- function(x, ...) max_if(diff(x, ...))
  
  l_name <- rlang::sym(glue::glue("l_diff_{lag}"))
  
  lognosticise(data = data,
               id = !!q_id,
               var = !!q_var,
               statistic = safe_diff,
               l_name = !!l_name,
               lag = lag,
               na.rm = TRUE)
  
}


#' Index of interestingness: n subjects
#'
#' Compute the number of observations for each individuals in the data
#' 
#' @inheritParams lognostic
#' @export
#' @examples
#' data(wages)
#' l_n_obs(wages, id, lnw)
#'
l_n_obs <- function(data, id, var) {
  
  q_id <- rlang::enquo(id)
  q_var <- rlang::enquo(var)
  
  lognosticise(data = data,
               id = !!q_id,
               var = !!q_var,
               statistic = length,
               l_name = l_n_obs)
  
}

#' Index of interestingness: slope
#'
#' Compute the maximum value for all individuals in the data

#' @inheritParams lognostic
#' @param formula character, a formula representing the slope of interest
#' @export
#' @examples
#' data(wages)
#' l_slope(wages, id, lnw~exper)
#'
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
    dplyr::rename_all(~c("id", "intercept", "slope"))

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