#' Stratify the keys into groups to facilitate exploration
#'
#' @param .data data.frame to explore
#' @param n_strata number of groups to create
#' @param along variable to stratify along. This groups by each `key` and then 
#'   takes a summary statistic (by default, the mean). It then arranges by the 
#'   mean value for each `key` and assigns the `n_strata` groups.
#' @param fun summary function. Default is mean.
#' @param ... extra arguments
#'
#' @return data.frame with column, `.strata` containing `n_strata` groups
#' @export
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
#'  
#'  # now facet along some feature
#'  
#' library(dplyr)
#'  wages_ts %>%
#' key_slope(ln_wages ~ xp) %>%
#'   right_join(wages_ts, ., by = "id") %>%
#'   stratify_keys(n_strata = 12,
#'                 along = .slope_xp,
#'                 fun = median) %>%
#'   ggplot(aes(x = xp,
#'              y = ln_wages,
#'              group = id)) + 
#'   geom_line() + 
#'   facet_wrap(~.strata)
#' 
#' 
#' wages_ts %>%
#'   stratify_keys(n_strata = 12,
#'                 along = unemploy_rate) %>%
#'   ggplot(aes(x = xp,
#'              y = ln_wages,
#'              group = id)) + 
#'   geom_line() + 
#'   facet_wrap(~.strata)
stratify_keys <- function(.data, n_strata, along = NULL, fun = mean, ...){
  test_if_tsibble(.data)
  test_if_null(.data)
  UseMethod("stratify_keys")
  
}
 
#' @export
stratify_keys.tbl_ts <- function(.data, 
                                 n_strata, 
                                 along = NULL, 
                                 fun = mean,
                                 ...){
  
  q_along <- rlang::enquo(along)
  
  possible_strata <- sample(x = 1:n_strata, 
                            size = tsibble::n_keys(.data), 
                            replace = TRUE)
  
  full_strata <- rep.int(possible_strata,
                         times = lengths(tsibble::key_rows(.data)))

  if (rlang::quo_is_null(q_along)) {
    
    data_strata <- .data %>%
      dplyr::mutate(.strata = full_strata)
    
    return(data_strata)
  } 
  
  if (!rlang::quo_is_null(q_along)) {
    
    data_strata <- .data %>%
      tibble::as_tibble() %>%
      dplyr::group_by(!!!tsibble::key(.data)) %>%
      dplyr::summarise(stat = fun(!!q_along, na.rm = TRUE)) %>%
      dplyr::arrange(-stat) %>%
      dplyr::mutate(.strata = sort(possible_strata)) %>%
      dplyr::select(-stat) %>%
      dplyr::right_join(.data,
                        .,
                        by = tsibble::key_vars(.data))
    
    return(data_strata)
  
  }
  
}