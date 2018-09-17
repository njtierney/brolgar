#' Index of interestingness: mean 
#'
#' Compute the mean for all individuals in the data
#' @param d vector of values for individuals, needs to match the id vector
#' @param id vector of ids to define which values belong to which individual
#' @export
#' @examples 
#' library(tidyverse)
#' data(wages)
#' m <- l_mean(wages, "id", "lnw")
#'
l_mean <- function(df, id, var) {
  sub <- df[,c(id, var)]
  l <- split(sub, sub[[id]])
  m <- map_dbl(l, ~mean(.x[[var]], na.rm=TRUE))  
  return(m)
}