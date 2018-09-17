#' Index of interestingness: mean 
#'
#' Compute the mean for all individuals in the data
#' @param d vector of values for individuals, needs to match the id vector
#' @param id vector of ids to define which values belong to which individual
#' @export
#' @examples 
#' library(tidyverse)
#' data(wages)
#' m <- l_mean(wages)
#'
l_mean <- function(df) {
  m <- df %>% split(.$id) %>% map(~mean(.$lnw, na.rm=TRUE)) %>% unlist(., use.names=FALSE)
  return(m)
}