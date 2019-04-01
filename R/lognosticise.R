#' Create a lognostic
#'
#' @param data data.frame
#' @param id id variable that uniquely identifies an individual
#' @param var variable to calculate the lognostic on 
#' @param statistic the summary statistic to calculate
#' @param l_name name to give the new column
#' @param ... parameters to pass to statistic
#'
#' @return data.frame of summaries
#' @export
#'
#' @examples
#' lognosticise(wages,
#'              id = id,
#'              var = lnw,
#'              mean,
#'              l_name = m,
#'              na.rm = TRUE)

lognosticise <- function(data, id, var, statistic, l_name, ...) {
  
  quo_id <- rlang::enquo(id)
  quo_var <- rlang::enquo(var)
  sym_l_name <- rlang::ensym(l_name)
  
  data %>%
    dplyr::group_by(!!quo_id) %>%
    dplyr::summarise_at(.vars = dplyr::vars(!!quo_var),
                 .funs = statistic,
                 ...) %>%
    dplyr::rename(!!sym_l_name := !!quo_var)
    
}

# # proof that this is the same
# 
# l_tidy <- wages %>%
#   group_by(id) %>%
#   summarise_at(.vars = "lnw",
#                .funs = mean,
#                na.rm = TRUE) %>%
#   rename(m = lnw)
# 
# l_previous <- l_mean(wages, "id", "lnw")
# 
# all.equal(l_tidy, l_previous)
# names(l_tidy)
# names(l_previous)
# 
