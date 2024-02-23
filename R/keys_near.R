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
#' # Return observations closest to the five number summary of height_cm
#' heights %>%
#'   keys_near(var = height_cm)
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
    dplyr::select(dplyr::all_of(key),
                  {{ var }},
                  dplyr::any_of(names(funs))) %>%
    tidyr::pivot_longer(cols = -c(dplyr::all_of(key), {{ var }}),
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
#' heights %>%
#'   key_slope(height_cm ~ year) %>%
#'   keys_near(key = country,
#'             var = .slope_year)
#' # Specify your own list of summaries
#' l_ranges <- list(min = b_min,
#'                  range_diff = b_range_diff,
#'                  max = b_max,
#'                  iqr = b_iqr)
#'
#' heights %>%
#'   key_slope(formula = height_cm ~ year) %>%
#'   keys_near(key = country,
#'               var = .slope_year,
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
                  dplyr::all_of(names(funs))) %>%
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

#' A named list of the five number summary
#' 
#' Designed for use with the [keys_near()] function.
#' @name l_funs
#' @examples 
#' # Specify your own list of summaries
#' l_ranges <- list(min = b_min,
#'                  range_diff = b_range_diff,
#'                  max = b_max,
#'                  iqr = b_iqr)
#'
#' heights %>%
#'   key_slope(formula = height_cm ~ year) %>%
#'   keys_near(key = country,
#'               var = .slope_year,
#'               funs = l_ranges)

#' @export
l_five_num <- list(
  min = b_min,
  q_25 = b_q25,
  med = b_median,
  q_75 = b_q75,
  max = b_max
)

#' @rdname l_funs
#' @export
l_three_num <- list(
  min = b_min,
  med = b_median,
  max = b_max
)