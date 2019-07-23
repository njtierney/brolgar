#' Stratify the keys into random groups to facilitate exploration
#'
#' @param .data data.frame to explore
#' @param n_strata number of random groups to create
#' @param along variable to stratify along
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
#'  ggplot(aes(x = ln_wages,
#'             y = xp,
#'             group = id)) + 
#'  geom_line() + 
#'  facet_wrap(~.strata)
stratify_keys <- function(.data, n_strata, along = NULL, ...){
  test_if_tsibble(.data)
  test_if_null(.data)
  UseMethod("stratify_keys")
  
}
 
#' @export
stratify_keys.tbl_ts <- function(.data, n_strata, along = NULL, ...){
  
  q_along <- rlang::enquo(along)
  
  possible_strata <- sample(x = 1:n_strata, 
                            size = tsibble::n_keys(.data), 
                            replace = TRUE)
  
  full_strata <- rep.int(possible_strata,
                         times = lengths(tsibble::key_rows(.data)))

  if (is.null(q_along)) {
    .data %>%
      dplyr::mutate(.strata = full_strata)
  } 
  
  if (!is.null(q_along)) {
    
    full_strata <- sort(full_strata)
    
    returned_data <- .data %>%
      dplyr::arrange(!!!tsibble::key(.data), 
                     !!tsibble::index(.data),
                     !!q_along) %>%
      dplyr::mutate(.strata = full_strata)
    
    return(returned_data)
  
  }
  
}