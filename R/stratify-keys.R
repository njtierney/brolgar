#' Stratify the keys into groups to facilitate exploration
#' 
#' To look at as much of the raw data as possible, it can be helpful to 
#'   stratify the data into groups for plotting. You can `stratify` the 
#'   `keys` using the `stratify_keys()` function, which adds the column, 
#'   `.strata`. This allows the user to create facetted plots showing a more 
#'   of the raw data. 
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
#' wages %>%
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
#'  wages %>%
#' key_slope(ln_wages ~ xp) %>%
#'   right_join(wages, ., by = "id") %>%
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
#' wages %>%
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
  
  if (rlang::quo_is_null(q_along)) {
  
    full_strata <- full_strata(.data, n_strata)
    
    data_strata <- .data %>%
      dplyr::mutate(.strata = full_strata)
    
    return(data_strata)
  } 
  
  if (!rlang::quo_is_null(q_along)) {
    
  possible_strata <- possible_strata(.data, n_strata)
  
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