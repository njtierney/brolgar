
#' Index helper - are there regular intervals between each index?
#'
#' @param .data data.frame or tsibble
#' @param index proposed index column
#'
#' @return logical. TRUE means it is regular, FALSE means not
#'
#' @examples
#' index_regular(pisa, year)
#' @export
index_regular <- function(.data, index){
  
  test_if_dataframe(.data)
  
  .data %>% 
    dplyr::distinct( {{ index }} ) %>% 
    dplyr::arrange( {{index }} ) %>% 
    dplyr::pull( {{index }} ) %>% 
    diff() %>% 
    unvarying() 
}

#' Index helper - summarise the distance between each index
#'
#' @param .data tsibble
#' @param index proposed index column
#'
#' @return summary of difference between each index
#' @examples
#' index_summary(pisa, year)
#' @export
index_summary <- function(.data, index){
  .data %>% 
    dplyr::distinct( {{index}} ) %>% 
    dplyr::arrange( {{index}} ) %>% 
    dplyr::pull( {{index}} ) %>% 
    diff() %>% 
    summary()
}