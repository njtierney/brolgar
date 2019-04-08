#' Filter by the number of observations for an individual
#' 
#' It can be useful to filter by
#'
#' @param data data.frame to explore
#' @param var vector of values for individuals, needs to match the id vector
#' @param id vector of ids to define which values belong to which individual
#' @param filter an expression you want to filter by, where numbser of obserations is referred in as `l_n_obs`. For example (`l_n_obs > 10`) would filter those observations with greater than 10 observations.
#'
#' @return dataframe filtered by the number of observations
#' @export
#'
#' @examples
#' wages %>% filter_n_obs(id = id, filter = l_n_obs > 10)
#' wages %>% filter_n_obs(id = id, filter = l_n_obs == 2)
#' 
filter_n_obs <- function(data, id, filter){
  
  quo_id <- rlang::enquo(id)
  quo_filter <- rlang::enquo(filter)

  data %>%
    add_l_n_obs(id = !!quo_id) %>%
    dplyr::filter(!!quo_filter)
  
}
