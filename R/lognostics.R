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

#' Index of interestingness: sd 
#'
#' Compute the standard deviation for all individuals in the data
#' @param d vector of values for individuals, needs to match the id vector
#' @param id vector of ids to define which values belong to which individual
#' @export
#' @examples 
#' library(tidyverse)
#' data(wages)
#' s <- l_sd(wages, "id", "lnw")
#'
l_sd <- function(df, id, var) {
  sub <- df[,c(id, var)]
  l <- split(sub, sub[[id]])
  m <- map_dbl(l, ~sd(.x[[var]], na.rm=TRUE))  
  return(m)
}

#' Index of interestingness: max 
#'
#' Compute the maximum value for all individuals in the data
#' @param d vector of values for individuals, needs to match the id vector
#' @param id vector of ids to define which values belong to which individual
#' @export
#' @examples 
#' library(tidyverse)
#' library(base)
#' data(wages)
#' m <- l_max(wages, "id", "lnw")
#'
l_max <- function(df, id, var) {
  sub <- df[,c(id, var)]
  l <- split(sub, sub[[id]])
  m <- map_dbl(l, ~max(.x[[var]], na.rm=TRUE))  
  return(m)
}
