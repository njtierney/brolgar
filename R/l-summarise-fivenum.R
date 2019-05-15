#' Calculate the five number summary of an id for a selected variable
#'
#' @param data data.frame
#' @param id id to select
#' @param var variable to summarise
#'
#' @return data.frame containing
#' @export
#'
#' @examples
#' wages %>%
#'   l_slope(id = id,
#'           formula = lnw ~ exper) %>%
#'   l_summarise_fivenum(id = id,
#'                       var = l_slope_exper)
#'                       
#' wages %>%
#'   l_summarise_fivenum(id = id,
#'                       var = lnw)
l_summarise_fivenum <- function(data,
                                id,
                                var){
  
  q_id <- rlang::enquo(id)
  q_var <- rlang::enquo(var)
  
  data %>%
    dplyr::mutate_all(.funs = list(min = b_min,
                                   max = b_max,
                                   median = b_median,
                                   q1 = b_q25,
                                   q3 = b_q75)) %>%
    dplyr::select(!!q_id,
                  dplyr::starts_with(rlang::as_label(q_var))) %>%
    tidyr::gather(key = "stat",
                  value = "stat_value",
           -!!q_id,
           -!!q_var) %>%
    dplyr::mutate(stat_diff = abs(!!q_var - stat_value)) %>%
    dplyr::group_by(stat) %>%
    dplyr::top_n(-1,
                 wt = stat_diff)
}