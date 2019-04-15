#' Calculate a longnostic
#'
#' @param data data.frame
#' @param id id variable that uniquely identifies an individual
#' @param var variable to calculate the longnostic on 
#' @param statistic the summary statistic to calculate
#' @param l_name name to give the new column
#' @param ... parameters to pass to statistic
#'
#' @return data.frame of summaries
#' @export
#'
#' @examples
#' longnostic(wages,
#'              id = id,
#'              var = lnw,
#'              mean,
#'              l_name = m,
#'              na.rm = TRUE)

longnostic <- function(data, id, var, statistic, l_name, ...) {
  
  quo_id <- rlang::enquo(id)
  quo_var <- rlang::enquo(var)
  sym_l_name <- rlang::ensym(l_name)
  
  data %>%
    dplyr::group_by(!!quo_id) %>%
    dplyr::summarise_at(.vars = dplyr::vars(!!quo_var),
                        .funs = sym_statistic,
                        ...) %>%
    dplyr::rename(!!sym_l_name := !!quo_var)
    
}
