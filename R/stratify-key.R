#' Add k groups to help explore ids
#'
#' @param .data data.frame to explore
#' @param n_strata number of random groups to create
#' @param ... extra arguments
#'
#' @return data.frame with additional column, `.strata` containing `n_strata` groups
#' @export
#'
#' @examples
#' library(ggplot2)
#' library(brolgar)
#' 
#' wages_ts %>%
#'   sample_frac_key(size = 0.1) %>%
#'   stratify_key(10) %>%
#'  ggplot(aes(x = lnw,
#'             y = exper,
#'             group = id)) + 
#'  geom_line() + 
#'  facet_wrap(~.strata)
stratify_key <- function(.data, n_strata, ...){
  UseMethod("stratify_key")
  
}
 
#' @export
stratify_key.tbl_ts <- function(.data, n_strata, ...){
  
  possible_strata <- sample(x = 1:n_strata, 
                            size = tsibble::n_keys(.data), 
                            replace = TRUE)
  
  full_strata <- rep.int(possible_strata,
                         times = lengths(tsibble::key_rows(.data)))

    .data %>%
    dplyr::mutate(.strata = full_strata)
}
  
#' @export
stratify_key.data.frame <- function(.data, n_strata, key, ...){

  q_key <- rlang::enquo(key)
  
  .data %>%
    dplyr::group_by(!!q_key) %>%
    tidyr::nest() %>%
    dplyr::mutate(.strata = sample(1:n_strata, 
                                   nrow(.), 
                                   replace = TRUE)) %>%
    tidyr::unnest()
}