#' Calculate all longnostics
#' 
#' This function calculates all longnostics:
#'  
#'  * [l_diff()]
#'  * [l_n_obs()]
#'  * [l_slope()]
#'
#' @inheritParams l_longnostic 
#'
#' @return a dataframe with longnostics
#' @export
#'
#' @examples
#' longnostic_all(wages, id = id, var = lnw, formula = lnw~exper)
longnostic_all <- function(data,
                           id,
                           var,
                           formula,
                           lag = 1){

quo_id <- rlang::enquo(id)
quo_var <- rlang::enquo(var)
quo_formula <- rlang::enquo(formula)

l_data_diff <- l_diff(data, 
                      id = !!quo_id,  
                      var = !!quo_var,
                      lag = lag)

l_data_n_obs <- l_n_obs(data, 
                        id = !!quo_id)

l_data_slope <- l_slope(data,
                        id = !!quo_id,
                        formula = !!quo_formula)

dplyr::left_join(l_data_diff, l_data_max, by = "id") %>%
  dplyr::left_join(l_data_n_obs, by = "id") %>%
  dplyr::left_join(l_data_slope, by = "id")

}