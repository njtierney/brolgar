#' Stratify the keys into random groups to facilitate exploration
#'
#' @param .data data.frame to explore
#' @param n_strata number of random groups to create
#' @param ... extra arguments
#'
#' @return data.frame with column, `.strata` containing `n_strata` groups
#' @export
#'
#' @examples
#' library(ggplot2)
#' library(brolgar)
#' 
#' wages_ts %>%
#'   sample_frac_keys(size = 0.1) %>%
#'   stratify_keys(10) %>%
#'  ggplot(aes(x = lnw,
#'             y = exper,
#'             group = id)) + 
#'  geom_line() + 
#'  facet_wrap(~.strata)
stratify_keys <- function(.data, n_strata, ...){
  test_if_tsibble(.data)
  test_if_null(.data)
  UseMethod("stratify_keys")
  
}
 
#' @export
stratify_keys.tbl_ts <- function(.data, n_strata, ...){
  
  possible_strata <- sample(x = 1:n_strata, 
                            size = tsibble::n_keys(.data), 
                            replace = TRUE)
  
  full_strata <- rep.int(possible_strata,
                         times = lengths(tsibble::key_rows(.data)))

    .data %>%
    dplyr::mutate(.strata = full_strata)
}