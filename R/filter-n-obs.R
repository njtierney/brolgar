#' Filter by the number of observations for an id.
#' 
#' When exploring longitudinal data it can be useful to 
#'   filter by the number of observations to help with certain exploratory
#'   data analysis.
#'
#' @param data data.frame to explore
#' @param id vector of ids to define which values belong to which individual
#' @param filter an expression you want to filter by, where number of 
#'   observations is referred in as `l_n_obs`. For example (`l_n_obs > 10`)
#'   would filter those observations with greater than 10 observations.
#'
#' @return dataframe filtered by the number of observations, with an additional column `l_n_obs` containing the number of observations for each `id`.
#' @export
#'
#' @examples
#' wages %>% filter_n_obs(id = id, filter = n_obs > 10)
#' wages %>% filter_n_obs(id = id, filter = n_obs == 2)
#' 
filter_n_obs <- function(data, ...){
  UseMethod("filter_n_obs")
}

#' @export
filter_n_obs.tbl_ts <- function(.data, filter, ...){
  
  quo_filter <- rlang::enquos(filter)

  add_l_n_obs(.data) %>% 
    dplyr::filter(!!!quo_filter)
  
}