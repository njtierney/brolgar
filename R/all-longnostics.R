#' Calculate all longnostics
#' 
#' This function calculates all longnostics:
#'  
#'  * [l_diff()]
#'  * [l_max()]
#'  * [l_mean()]
#'  * [l_median()]
#'  * [l_min()]
#'  * [l_n_obs()]
#'  * [l_q1()]
#'  * [l_q3()]
#'  * [l_sd()]
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

l_data_max <- l_max(data, 
                    id = !!quo_id,  
                    var = !!quo_var)

l_data_mean <- l_mean(data,
                      id = !!quo_id, 
                      var = !!quo_var)

l_data_median <- l_median(data, 
                          id = !!quo_id,  
                          var = !!quo_var)

l_data_min <- l_min(data, 
                    id = !!quo_id,  
                    var = !!quo_var)

l_data_n_obs <- l_n_obs(data, 
                        id = !!quo_id,  
                        var = !!quo_var)

l_data_q1 <- l_q1(data, 
                  id = !!quo_id,  
                  var = !!quo_var)

l_data_q3 <- l_q3(data, 
                  id = !!quo_id,  
                  var = !!quo_var)

l_data_sd <- l_sd(data, 
                  id = !!quo_id,  
                  var = !!quo_var)
# 
l_data_slope <- l_slope(data,
                        id = !!quo_id,
                        formula = !!quo_formula)

dplyr::left_join(l_data_diff, l_data_max, by = "id") %>%
  dplyr::left_join(l_data_mean, by = "id") %>%
  dplyr::left_join(l_data_median, by = "id") %>%
  dplyr::left_join(l_data_min, by = "id") %>%
  dplyr::left_join(l_data_n_obs, by = "id") %>%
  dplyr::left_join(l_data_q1, by = "id") %>%
  dplyr::left_join(l_data_q3, by = "id") %>%
  dplyr::left_join(l_data_sd, by = "id") %>%
  dplyr::left_join(l_data_slope, by = "id")

}