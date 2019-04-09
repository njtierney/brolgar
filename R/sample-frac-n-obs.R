#' Sample a fraction of ids to explore
#'
#' @param data data.frame to explore
#' @param id vector of ids to define which values belong to which individual
#' @param size The number or fraction of observations, depending on the 
#'   function used. In `sample_n_obs`, it is a number > 0, and in 
#'   `sample_frac_obs` it is a fraction, between 0 and 1.
#'
#' @return data.frame with fewer observations of id
#' @rdname sample-n-frac-obs
#' @export
#' @examples
#' library(ggplot2)
#' sample_n_obs(wages,
#'              id,
#'              10) %>%
#'   ggplot(aes(x = exper,
#'              y = uerate,
#'              group = id)) + 
#'   geom_line()
sample_n_obs <- function(data, id, size){
  
  q_id <- rlang::enquo(id)
  
  data %>%
    dplyr::group_by(!!q_id) %>%
    tidyr::nest() %>%
    dplyr::sample_n(size = size) %>%
    tidyr::unnest()
  
}

#' @name sample-n-frac-obs
#' @examples
#' library(ggplot2)
#' sample_frac_obs(wages,
#'                 id,
#'                 0.1) %>%
#'   ggplot(aes(x = exper,
#'              y = uerate,
#'              group = id)) + 
#'   geom_line()
#' @export
sample_frac_obs <- function(data, id, size){
  
  q_id <- rlang::enquo(id)
  
  data %>%
    dplyr::group_by(!!q_id) %>%
    tidyr::nest() %>%
    dplyr::sample_frac(size = size) %>%
    tidyr::unnest()
  
}