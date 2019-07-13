#' Return keys nearest to given summary statistics.
#'
#' @param .data data.frame
#' @param key key, which identifies unique observations.
#' @param var variable to summarise
#' @param funs named list of functions to summarise by. Default is a given
#'   list of the five number summary, `l_five_num`.
#'
#' @return data.frame containing keys closest to a given statistic.
#' @export
#'
#' @examples
#' wages_ts %>%
#'   key_slope(key = id,
#'           formula = ln_wages ~ xp) %>%
#'   l_summarise(key = id,
#'               var = l_slope_xp)
#'                
#' # Return observations closest to the five number summary of ln_wages
#' wages_ts %>%
#'   l_summarise(key = id,
#'               var = ln_wages)
#'                
#' # Specify your own list of summaries
#' l_ranges <- list(min = b_min,
#'                  range_diff = b_range_diff,
#'                  max = b_max,
#'                  iqr = b_iqr)
#'
#' wages_ts %>%
#'   key_slope(key = id,
#'             formula = ln_wages ~ xp) %>%
#'   l_summarise(key = id,
#'               var = .slope_xp,
#'               funs = l_ranges)
l_summarise <- function(.data,
                        key,
                        var,
                        funs = l_five_num){
  
  .data %>%
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
