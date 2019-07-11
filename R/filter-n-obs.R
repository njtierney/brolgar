#' Filter by the number of observations for a `key`.
#' 
#' When exploring longitudinal data it can be useful to filter by the number of
#'   observations in a compact way. `filter_n_obs` allows for the user to 
#'   filter by the number of observations for each `key`.
#'
#' @param .data data.frame
#' @param filter A description of how you want to filter the number of 
#'   observations for each `key`, in terms of `n_obs`. See examples for more
#'   detail.
#'
#' @return data.frame filtered by the number of observations, with an 
#'   additional column `n_obs`, which contains the number of observations for
#'   each `key`.
#' @export
#' @name filter_n_obs
#'
#' @examples
#' wages_ts %>% filter_n_obs(n_obs > 10)
#' wages_ts %>% filter_n_obs(n_obs == 2)
#' 
filter_n_obs <- function(.data, filter, ...){
  test_if_tsibble(.data)
  test_if_null(.data)
  UseMethod("filter_n_obs")
}

#' @rdname filter_n_obs
#' @export
filter_n_obs.tbl_ts <- function(.data, filter, ...){
  
  quo_filter <- rlang::enquos(filter)

  add_l_n_obs(.data) %>% 
    dplyr::filter(!!!quo_filter)
  
}