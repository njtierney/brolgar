#' Index of interestingness: sd 
#'
#' Compute the standard deviation for all individuals in the data
#' @param d vector of values for individuals, needs to match the id vector
#' @param id vector of ids to define which values belong to which individual
#' @export
#' @examples 
#' library(tidyverse)
#' df <- tibble(d=c(1,2,3,1,5,10,12), id=c(rep("A", 3), rep("B", 4)))
#' l_sd(df$d, df$id)
#'
l_sd <- function(d, id) {
  n <- length(unique(id))
  ids <- unique(id)
  sd <- NULL
  for (i in 1:n){
    x <- d[id == ids[i]]
    sd <- c(sd, sd(x, na.rm=T))
  }
  return(sd)
}