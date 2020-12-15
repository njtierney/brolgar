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
#' heights %>%
#'   sample_frac_keys(size = 0.1) %>%
#'   stratify_keys(10) %>%
#'  ggplot(aes(x = height_cm,
#'             y = year,
#'             group = country)) + 
#'  geom_line() + 
#'  facet_wrap(~.strata)
#'  
#'  # now facet along some feature
#' library(dplyr)
#'  heights %>%
#' key_slope(height_cm ~ year) %>%
#'   right_join(heights, ., by = "country") %>%
#'   stratify_keys(n_strata = 12,
#'                 along = .slope_year,
#'                 fun = median) %>%
#'   ggplot(aes(x = year,
#'              y = height_cm,
#'              group = country)) + 
#'   geom_line() + 
#'   facet_wrap(~.strata)
#' 
#' 
#' heights %>%
#'   stratify_keys(n_strata = 12,
#'                 along = height_cm) %>%
#'   ggplot(aes(x = year,
#'              y = height_cm,
#'              group = country)) + 
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
  q_keys <- tsibble::key(.data)
  keys_chr <- tsibble::key_vars(.data)
  
  if (rlang::quo_is_null(q_along)) {
  
  # stratify(.data, n_strata)
  # could just return some vector of numbers?
  # perhaps that is the difference btn strata and stratify
  # strata returns a vector, stratify adds this to the data?
    full_strata <- full_strata(.data, n_strata)
    
    data_strata <- .data %>%
      dplyr::mutate(.strata = full_strata)
    # .strata = stratify(n_strata)
    
    return(data_strata)
  } 
  
  if (!rlang::quo_is_null(q_along)) {
    
  # stratify_along(.data, 
                 # n_strata, 
                 # along, - aka q_along
                 # keys) - aka q_keys (can we generate keys_chr from q_keys?)
                  
  possible_strata <- possible_strata(.data, n_strata)
  
    data_strata <- .data %>%
      tibble::as_tibble() %>%
      dplyr::group_by(!!!q_keys) %>%
      dplyr::summarise(stat = fun(!!q_along, na.rm = TRUE)) %>%
      dplyr::arrange(-stat) %>%
      dplyr::mutate(.strata = sort(possible_strata)) %>%
      dplyr::select(-stat) %>%
      dplyr::right_join(.data,
                        .,
                        by = keys_chr)
    
    return(data_strata)
  
  }
  
}