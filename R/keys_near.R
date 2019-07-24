#' Return keys nearest to a given statistics or summary. 
#'
#' @param .data data.frame
#' @param key key, which identifies unique observations.
#' @param var variable to summarise
#' @param funs named list of functions to summarise by. Default is a given
#'   list of the five number summary, `l_five_num`.
#'
#' @return data.frame containing keys closest to a given statistic.
#' @examples
#' wages_ts %>%
#'   key_slope(ln_wages ~ xp) %>%
#'   keys_near(key = id,
#'             var = .slope_xp)
#'                
#' # Return observations closest to the five number summary of ln_wages
#' wages_ts %>%
#'   keys_near(key = id,
#'             var = ln_wages)
#'                
#' # Specify your own list of summaries
#' l_ranges <- list(min = b_min,
#'                  range_diff = b_range_diff,
#'                  max = b_max,
#'                  iqr = b_iqr)
#'
#' wages_ts %>%
#'   key_slope(formula = ln_wages ~ xp) %>%
#'   keys_near(key = id,
#'               var = .slope_xp,
#'               funs = l_ranges)
#' @export
keys_near <- function(.data,
                      key,
                      var,
                      funs = l_five_num){
  
  .data %>%
    tibble::as_tibble() %>%
    dplyr::mutate_at(
      .vars = dplyr::vars({{var}}),
      .funs = funs) %>%
    dplyr::select({{key}},
                  {{var}},
                  dplyr::one_of(names(funs))) %>%
    tidyr::gather(key = "stat",
                  value = "stat_value",
           -{{key}},
           -{{var}}) %>%
    dplyr::mutate(stat_diff = abs({{var}} - stat_value)) %>%
    dplyr::group_by(stat) %>%
    dplyr::top_n(-1,
                 wt = stat_diff)
}
