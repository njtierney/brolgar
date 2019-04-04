#' Add longnostic to data
#' 
#' Adds a longnostic to the original dataframe
#'
#' @param data dataframe
#' @param id id that uniquely identifies individual
#' @param var variable to calculate summary of
#'
#' @return dataframe with longnostic
#' @name add-longnostic
#' @export
#'
#' @examples
#' add_l_max(data = wages,
#'           id = id,
#'           var = lnw)
add_l_max <- function(data,
                      id,
                      var){
  
  quo_id <- rlang::enquo(id)
  quo_var <- rlang::enquo(var)
  
  str_id <- rlang::as_label(rlang::enquo(id))

l_max(data,
      !!quo_id,
      !!quo_var) %>%
  dplyr::left_join(data,
                   by = str_id)

}
