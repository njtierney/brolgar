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
#'  * `l_diff()` Lagged difference (by default, the first order difference)
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
#' l_diff(wages, id, lnw)
#' l_diff(wages, id, lnw, lag = 2)
#' l_n_obs(wages, id)
#' l_slope(wages, id, lnw~exper)
NULL

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

#' Add a longnostic to a dataframe
#' 
#' Match a longnostic to the id of a dataframe. This saves you creating a
#'   longnostic and then joining it back to a dataframe
#' @inheritParams l_longnostic
#' @name add_longnostic
#' @examples
#' add_l_diff(data = wages, id = id, var = lnw)
#' add_l_diff(data = wages, id = id, var = lnw, lag = 2)
#' @export

#' @rdname add_longnostic
#' @export
add_l_diff <- function(data,
                       id,
                       var,
                       lag = 1){
  
  quo_id <- rlang::enquo(id)
  quo_var <- rlang::enquo(var)
  
  str_id <- rlang::as_label(quo_id)
  
  l_diff(data = data,
         id = !!quo_id,
         var = !!quo_var,
         lag = lag) %>%
    dplyr::left_join(data,
                     by = str_id)
  
}
