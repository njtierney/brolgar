#' Return keys nearest to a given statistics or summary. 
#'
#' @param .data tsibble
#' @param ... extra arguments to pass to `mutate_at` when performing the summary
#'   as given by `funs`.
#'
#' @return data.frame containing keys closest to a given statistic.
#' 
#' @examples 
#' keys_near(heights, height_cm)
#' 
#' @export
 keys_near <- function(.data, ...){
  
  UseMethod("keys_near")
  
}

#' @title Return keys nearest to a given statistics or summary. 
#' @inheritParams keys_near
#' @param var variable to summarise
#' @param top_n top number of closest observations to return - default is 1, which will also return ties.
#' @param funs named list of functions to summarise by. Default is a given
#'   list of the five number summary, `l_five_num`.
#' @param stat_as_factor coerce `stat` variable into a factor? Default is TRUE.
#' @export
#' @examples
#'                
#' # Return observations closest to the five number summary of ln_wages
#' wages %>%
#'   keys_near(var = ln_wages)
#'                

keys_near.tbl_ts <- function(.data,
                      var,
                      top_n = 1,
                      funs = l_five_num,
                      stat_as_factor = TRUE,
                      ...){

  key <- tsibble::key_vars(.data)
  
  data_keys_near <- .data %>%
    tibble::as_tibble() %>%
    dplyr::mutate_at(
      .vars = dplyr::vars( {{ var }} ),
      .funs = funs,
      ...) %>%
    dplyr::select(key,
                  {{ var }},
                  dplyr::one_of(names(funs))) %>%
    tidyr::pivot_longer(cols = -c(key, {{ var }}),
                        names_to = "stat",
                        values_to = "stat_value") %>% 
    dplyr::mutate(stat_diff = abs({{ var }} - stat_value)) %>%
    dplyr::group_by(stat) %>%
    dplyr::top_n(-top_n,
                 wt = stat_diff) %>% 
    dplyr::ungroup()
  
  # set factors
  if (isTRUE(stat_as_factor)) {
    data_keys_near %>%
      dplyr::mutate(stat = factor(x = stat,
                                  levels = names(funs)))
  } else if (! stat_as_factor) {
    return(data_keys_near)
  }
  
}

#' @title Return keys nearest to a given statistics or summary. 
#' @param .data data.frame
#' @param key key, which identifies unique observations.
#' @param var variable to summarise
#' @param top_n top number of closest observations to return - default is 1, which will also return ties.
#' @param funs named list of functions to summarise by. Default is a given
#'   list of the five number summary, `l_five_num`.
#' @param ... extra arguments to pass to `mutate_at` when performing the summary
#'   as given by `funs`.
#' @examples
#' wages %>%
#'   key_slope(ln_wages ~ xp) %>%
#'   keys_near(key = id,
#'             var = .slope_xp)
#' # Specify your own list of summaries
#' l_ranges <- list(min = b_min,
#'                  range_diff = b_range_diff,
#'                  max = b_max,
#'                  iqr = b_iqr)
#'
#' wages %>%
#'   key_slope(formula = ln_wages ~ xp) %>%
#'   keys_near(key = id,
#'               var = .slope_xp,
#'               funs = l_ranges)
#' @export
keys_near.data.frame <- function(.data,
                      key,
                      var,
                      top_n = 1,
                      funs = l_five_num,
                      ...){
  
  .data %>%
    tibble::as_tibble() %>%
    dplyr::mutate_at(
      .vars = dplyr::vars( {{ var }} ),
      .funs = funs,
      ...) %>%
    dplyr::select( {{ key }},
                   {{ var }},
                  dplyr::one_of(names(funs))) %>%
    tidyr::pivot_longer(cols = -c( {{ key }}, {{ var }}),
                        names_to = "stat",
                        values_to = "stat_value") %>% 
    dplyr::mutate(stat_diff = abs( {{ var }} - stat_value)) %>%
    dplyr::group_by(stat) %>%
    dplyr::top_n(-top_n,
                 wt = stat_diff) %>%
    dplyr::ungroup() %>%
    dplyr::mutate(stat = factor(x = stat,
                                 levels = names(funs)))
}

#' @rdname keys_near 
#' @param ... extra arguments to pass to `mutate_at` when performing the summary
#'   as given by `funs`.
#' @export 
keys_near.default <- function(.data, ...){
  
  stop(.data, "must be a data.frame or tsibble, class is ", class(.data))
  
}